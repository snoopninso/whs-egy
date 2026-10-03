import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whs_egy/core/app_persistence.dart';
import 'package:whs_egy/core/user_qr_token.dart';
import 'package:whs_egy/features/register/registered_user_qr_dialog.dart';

void main() {
  test('each registration receives a distinct UUID token', () {
    final tokens = List.generate(100, (_) => createUserQrToken());

    expect(tokens.toSet(), hasLength(100));
    expect(tokens.first, matches(RegExp(r'^[0-9a-f-]{36}$')));
  });

  testWidgets('QR dialog encodes only the supplied user token', (tester) async {
    const token = 'c1e8be3d-24e7-4e4a-a7a8-3ee4e2ca30f8';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RegisteredUserQrDialog(token: token)),
      ),
    );

    final dialog = tester.widget<RegisteredUserQrDialog>(
      find.byType(RegisteredUserQrDialog),
    );
    expect(dialog.token, token);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text(token), findsNothing);
  });

  test(
    'registration persistence keeps the QR token with its own record',
    () async {
      SharedPreferences.setMockInitialValues({});
      final token = createUserQrToken();

      await AppPersistence.saveRegistrationRequest({
        'full_name': 'Example User',
        'email': 'user@example.com',
        'qr_token': token,
      });

      final preferences = await SharedPreferences.getInstance();
      final records = preferences.getStringList('registration_requests')!;
      final savedRecord = jsonDecode(records.single) as Map<String, dynamic>;

      expect(savedRecord['qr_token'], token);
    },
  );
}
