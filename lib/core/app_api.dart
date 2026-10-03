import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AppApiException implements Exception {
  const AppApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AppApi {
  AppApi({
    http.Client? client,
    String? baseUrl,
    String? loginPath,
    String? registrationPath,
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL'),
       _loginPath =
           loginPath ??
           const String.fromEnvironment(
             'API_LOGIN_PATH',
             defaultValue: 'auth/login',
           ),
       _registrationPath =
           registrationPath ??
           const String.fromEnvironment(
             'API_REGISTRATION_PATH',
             defaultValue: 'registrations',
           );

  final http.Client _client;
  final String _baseUrl;
  final String _loginPath;
  final String _registrationPath;

  Future<void> login({required String email, required String password}) {
    return _post(_loginPath, {'email': email, 'password': password});
  }

  Future<void> submitRegistration(Map<String, String> request) {
    return _post(_registrationPath, request);
  }

  Future<void> _post(String path, Map<String, String> data) async {
    if (_baseUrl.trim().isEmpty) {
      throw const AppApiException(
        'The service is not configured yet. Please try again later.',
      );
    }

    try {
      final base = Uri.parse(_baseUrl.endsWith('/') ? _baseUrl : '$_baseUrl/');
      final response = await _client
          .post(
            base.resolve(path),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AppApiException(_errorMessage(response));
      }
    } on AppApiException {
      rethrow;
    } on TimeoutException {
      throw const AppApiException(
        'The server took too long to respond. Please try again.',
      );
    } on http.ClientException {
      throw const AppApiException(
        'Could not connect to the server. Check your internet connection.',
      );
    } on FormatException {
      throw const AppApiException('The API address is invalid.');
    }
  }

  String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body['message'] is String) {
        return body['message'] as String;
      }
    } on FormatException {
      // Use the status code when the server does not return JSON.
    }
    return 'The request failed (HTTP ${response.statusCode}).';
  }

  void dispose() => _client.close();
}
