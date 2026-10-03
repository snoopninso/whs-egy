import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whs_egy/core/app_persistence.dart';
import 'package:whs_egy/features/register/my_qr_screen.dart';
import 'package:whs_egy/features/register/my_registration_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'My Registration displays saved user details and submitted status',
    (tester) async {
      await AppPersistence.saveRegistrationRequest({
        'full_name': 'Example User',
        'email': 'user@example.com',
        'qr_token': 'user-token-1',
      });

      await tester.pumpWidget(const MaterialApp(home: MyRegistrationScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Submitted'), findsOneWidget);
      expect(find.text('Example User'), findsOneWidget);
      expect(find.text('user@example.com'), findsOneWidget);
    },
  );

  testWidgets('My QR displays the saved personal QR code', (tester) async {
    await AppPersistence.saveRegistrationRequest({
      'full_name': 'Example User',
      'email': 'user@example.com',
      'qr_token': 'user-token-1',
    });

    await tester.pumpWidget(const MaterialApp(home: MyQrScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('Example User'), findsNothing);
    expect(find.text('user@example.com'), findsNothing);
  });
}
