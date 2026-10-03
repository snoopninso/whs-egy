import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:whs_egy/core/app_info.dart';
import 'package:whs_egy/core/app_assets.dart';
import 'package:whs_egy/features/home/home_screen.dart';
import 'package:whs_egy/features/venue/venue_screen.dart';
import 'package:whs_egy/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WHSEgyApp());
  });

  testWidgets('Home hero does not show Program or Registration buttons', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Explore Program →'), findsNothing);
    expect(find.text('Registration'), findsNothing);
  });

  testWidgets('Home does not show a registration status panel', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Registration Status'), findsNothing);
  });

  testWidgets('Home hero presents the logo larger than its former size', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final heroLogo = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.whsHero,
    );
    final imageSize = tester.getSize(heroLogo);

    expect(imageSize.width, greaterThan(140));
    expect(find.text('WHS Egypt\n2026'), findsOneWidget);
  });

  test('Contact metadata includes the official WhatsApp and phone numbers', () {
    expect(AppInfo.primaryPhoneNumber, '+201020180180');
    expect(AppInfo.whatsappNumber, '+201095828282');
    expect(AppInfo.organizerPhone, '+201020180180 · +201095828282');
  });

  testWidgets('Event Management logo has its own single home section', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.scrollUntilVisible(
      find.text('Event Management'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final organizerLogos = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.organizerLogo,
    );

    expect(find.text('Event Management'), findsOneWidget);
    expect(organizerLogos, findsOneWidget);
  });

  testWidgets('government authority logos are displayed larger', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.scrollUntilVisible(
      find.text('OFFICIAL ORGANIZING AUTHORITY'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final ministryLogo = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == AppAssets.ministryLogo,
    );

    expect(ministryLogo, findsOneWidget);
    expect(tester.getSize(ministryLogo).width, 88);
    expect(tester.getSize(ministryLogo).height, 88);
  });

  testWidgets('Ministry of Interior appears above Police Medical Services', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.scrollUntilVisible(
      find.text('OFFICIAL MEDICAL SERVICES'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final ministryTop = tester
        .getTopLeft(find.text('OFFICIAL ORGANIZING AUTHORITY'))
        .dy;
    final medicalTop = tester
        .getTopLeft(find.text('OFFICIAL MEDICAL SERVICES'))
        .dy;

    expect(ministryTop, lessThan(medicalTop));
  });

  testWidgets('Venue page exposes an active Google Maps button', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VenueScreen()));

    final mapButton = find.widgetWithText(
      OutlinedButton,
      'Open in Google Maps',
    );

    expect(mapButton, findsOneWidget);
    expect(tester.widget<OutlinedButton>(mapButton).onPressed, isNotNull);
    expect(AppInfo.venueMapUrl, contains('google.com/maps/search/'));
  });
}
