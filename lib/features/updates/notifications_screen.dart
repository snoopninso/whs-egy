import 'package:material_ui/material_ui.dart';

import '../../theme/whs_theme.dart';
import '../../widgets/section_page_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
              children: [
                const SectionPageHeader(
                  eyebrow: 'Updates',
                  title: 'Notifications',
                  subtitle: 'Conference announcements and updates.',
                ),
                const SizedBox(height: 48),
                const Icon(
                  Icons.notifications_none_rounded,
                  color: WhsColors.teal,
                  size: 46,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No notifications yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: WhsColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
