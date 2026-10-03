import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:whs_egy/data/program_data.dart';
import 'package:whs_egy/features/program/program_topic_detail_screen.dart';
import 'package:whs_egy/features/program/program_topics_screen.dart';

void main() {
  test('program topics include all 21 supplied bilingual titles', () {
    expect(ProgramRepository.topics, hasLength(21));
    expect(ProgramRepository.days, hasLength(2));
    expect(ProgramRepository.sessions, hasLength(3));
    expect(ProgramRepository.topics.first.title, 'Women’s Health Screening');
    expect(
      ProgramRepository.topics.last.arabicTitle,
      'العلاج الطبيعي في مجال صحة المرأة',
    );
  });

  testWidgets('program screen displays the existing Day 01 schedule by time', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProgramScreen()));

    expect(find.text('SCHEDULE'), findsOneWidget);
    expect(find.text('DAY 01'), findsOneWidget);
    expect(find.text('05 October'), findsWidgets);
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('Opening Session'), findsOneWidget);
    expect(find.text('Welcome & Summit Opening'), findsOneWidget);
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('Day 02 shows no invented sessions', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProgramScreen()));
    await tester.tap(find.text('06 October').first);
    await tester.pumpAndSettle();

    expect(find.text('Day 02 · 06 October'), findsOneWidget);
    expect(
      find.text('No scheduled sessions are available for this day or search.'),
      findsOneWidget,
    );
    expect(find.text('Opening Session'), findsNothing);
  });

  testWidgets('topic details remain accessible from the secondary topic list', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProgramScreen()));

    await tester.scrollUntilVisible(
      find.text('Scientific topics'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Scientific topics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Women’s Health Screening'));
    await tester.pumpAndSettle();

    expect(find.text('TOPIC 01'), findsOneWidget);
    expect(find.text('Women’s Health Screening'), findsOneWidget);
    expect(find.text('الفحص والكشف المبكر لصحة المرأة'), findsOneWidget);
  });

  testWidgets('program search filters Arabic topics and can be cleared', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProgramScreen()));

    await tester.enterText(find.byType(TextField), 'الولادة الآمنة');
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Safe Childbirth'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.textContaining('1 topic'), findsOneWidget);
    expect(find.text('Safe Childbirth'), findsOneWidget);
    expect(find.text('Women’s Health Screening'), findsNothing);

    await tester.scrollUntilVisible(
      find.byTooltip('Clear search'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Scientific topics'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.textContaining('21 topics'), findsOneWidget);
  });

  testWidgets('topic detail displays populated default information fields', (
    tester,
  ) async {
    const topic = ProgramTopic(
      number: 1,
      title: 'Women’s Health Screening',
      arabicTitle: 'الفحص والكشف المبكر لصحة المرأة',
      description: 'Screening and early detection services.',
      arabicDescription: 'خدمات الفحص والكشف المبكر.',
      date: '05 October 2026',
      time: '10:00',
      location: 'Cairo Marriott Hotel',
      speakers: ['Dr. Example'],
    );

    await tester.pumpWidget(
      const MaterialApp(home: ProgramTopicDetailScreen(topic: topic)),
    );

    expect(
      find.text('Screening and early detection services.'),
      findsOneWidget,
    );
    expect(find.text('خدمات الفحص والكشف المبكر.'), findsOneWidget);
    expect(find.text('05 October 2026'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    expect(find.text('Cairo Marriott Hotel'), findsOneWidget);
    expect(find.text('Dr. Example'), findsOneWidget);
  });
}
