import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:whs_egy/core/app_api.dart';

void main() {
  test('does not send credentials when the API base URL is not configured', () {
    final client = _RecordingClient();
    final api = AppApi(client: client);
    addTearDown(api.dispose);

    expect(
      () => api.login(email: 'person@example.com', password: 'secret123'),
      throwsA(isA<AppApiException>()),
    );
    expect(client.lastRequest, isNull);
  });

  test('posts login credentials to the configured API path', () async {
    final client = _RecordingClient();
    final api = AppApi(client: client, baseUrl: 'https://api.example.test/v1/');
    addTearDown(api.dispose);

    await api.login(email: 'person@example.com', password: 'secret123');

    expect(client.lastRequest?.url.path, '/v1/auth/login');
    expect(jsonDecode(client.lastRequest!.body), {
      'email': 'person@example.com',
      'password': 'secret123',
    });
  });

  test('posts registration fields to the configured API path', () async {
    final client = _RecordingClient();
    final api = AppApi(client: client, baseUrl: 'https://api.example.test/v1/');
    addTearDown(api.dispose);

    await api.submitRegistration({
      'full_name': 'Example Person',
      'email': 'person@example.com',
      'organization': 'Example Hospital',
      'job_title': 'Physician',
      'phone': '+201000000000',
      'attendance_type': 'In-person',
      'message': 'Please contact me',
    });

    expect(client.lastRequest?.url.path, '/v1/registrations');
    expect(jsonDecode(client.lastRequest!.body), {
      'full_name': 'Example Person',
      'email': 'person@example.com',
      'organization': 'Example Hospital',
      'job_title': 'Physician',
      'phone': '+201000000000',
      'attendance_type': 'In-person',
      'message': 'Please contact me',
    });
  });

  test('reports server errors instead of treating them as success', () async {
    final client = _RecordingClient(
      statusCode: 401,
      responseBody: '{"message":"Invalid credentials"}',
    );
    final api = AppApi(client: client, baseUrl: 'https://api.example.test/');
    addTearDown(api.dispose);

    await expectLater(
      api.login(email: 'person@example.com', password: 'secret123'),
      throwsA(
        isA<AppApiException>().having(
          (error) => error.message,
          'message',
          'Invalid credentials',
        ),
      ),
    );
  });
}

class _RecordingClient extends http.BaseClient {
  _RecordingClient({this.statusCode = 200, this.responseBody = '{}'}) : super();

  final int statusCode;
  final String responseBody;
  http.Request? lastRequest;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastRequest = request as http.Request;
    return http.StreamedResponse(
      Stream.value(utf8.encode(responseBody)),
      statusCode,
      request: request,
    );
  }
}
