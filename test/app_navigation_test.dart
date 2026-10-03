import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whs_egy/core/localization/app_language.dart';
import 'package:whs_egy/features/home/app_navigation_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppLanguage.languageCode.value = 'en';
  });

  testWidgets('main navigation and More expose requested app sections', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AppNavigationScreen()));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Program'), findsWidgets);
    expect(find.text('Speakers'), findsWidgets);
    expect(find.text('My QR'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);

    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();

    expect(find.text('My Registration'), findsOneWidget);
    expect(find.text('Venue'), findsOneWidget);
    expect(find.text('National Agenda'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Language'),
      300,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Partners'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
  });

  testWidgets('language selection updates the app navigation language', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AppNavigationScreen()));
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Language'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('المزيد'), findsWidgets);
  });
}
