import 'package:material_ui/material_ui.dart';

import '../data/organization_data.dart';
import '../data/program_data.dart';
import '../features/contact/contact_screen.dart';
import '../features/home/app_navigation_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/more_screen.dart';
import '../features/national_agenda/agenda_detail_screen.dart';
import '../features/national_agenda/national_agenda_screen.dart';
import '../features/partners/partners_screen.dart';
import '../features/program/program_topics_screen.dart';
import '../features/program/program_topic_detail_screen.dart';
import '../features/program/session_detail_screen.dart';
import '../features/register/my_qr_screen.dart';
import '../features/register/my_registration_screen.dart';
import '../features/register/register_screen.dart';
import '../features/speakers/speaker_detail_screen.dart';
import '../features/speakers/speakers_screen.dart';
import '../features/updates/notifications_screen.dart';
import '../features/venue/venue_screen.dart';

class AppNavigator {
  const AppNavigator._();

  static void pushHome(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AppNavigationScreen()));
  }

  static void pushMore(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const MoreScreen()));
  }

  static void pushProgram(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ProgramScreen()));
  }

  static void openProgram(BuildContext context) => pushProgram(context);
  static void pushProgramTopic(BuildContext context, ProgramTopic topic) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProgramTopicDetailScreen(topic: topic)),
    );
  }

  static void pushSessionDetail(BuildContext context, String sessionId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SessionDetailScreen(sessionId: sessionId),
      ),
    );
  }

  static void pushSpeakers(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SpeakersScreen()));
  }

  static void openSpeakers(BuildContext context) => pushSpeakers(context);

  static void pushSpeakerDetail(BuildContext context, String speakerId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpeakerDetailScreen(speakerId: speakerId),
      ),
    );
  }

  static void pushNationalAgenda(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const NationalAgendaScreen()));
  }

  static void pushAgendaDetail(BuildContext context, String topicId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AgendaDetailScreen(itemId: topicId)),
    );
  }

  static void pushPartners(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const PartnersScreen()));
  }

  static void pushVenue(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const VenueScreen()));
  }

  static void pushRegister(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  static void pushMyRegistration(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const MyRegistrationScreen()));
  }

  static void pushMyQr(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const MyQrScreen()));
  }

  static void pushNotifications(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
  }

  static void pushContact(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ContactScreen()));
  }

  static void pushOrganizationDetail(
    BuildContext context,
    OrganizationInfo info,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OrganizationDetailScreen(info: info)),
    );
  }

  /// /app uses Contact; kept for compatibility with older call sites.
  static void pushUpdates(BuildContext context) => pushContact(context);
}
