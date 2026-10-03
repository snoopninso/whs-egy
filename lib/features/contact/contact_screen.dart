import 'package:material_ui/material_ui.dart';

import '../../core/app_assets.dart';
import '../../core/app_info.dart';
import '../../theme/whs_theme.dart';
import '../../widgets/section_page_header.dart';

/// Contact page aligned with /app Contact navigation and contact-card layout.
///
/// Event-management details come from /app/assets/script.js.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const details = [
      ('EMAIL', AppInfo.conferenceEmail),
      ('EVENT MANAGEMENT', AppInfo.organizerName),
      ('WEBSITE', AppInfo.organizerWebsite),
      ('ORGANIZER EMAIL', AppInfo.organizerEmail),
      ('PHONE', AppInfo.primaryPhoneNumber),
      ('WHATSAPP', AppInfo.whatsappNumber),
      ('VENUE', AppInfo.venueName),
      ('ADDRESS', AppInfo.organizerAddress),
    ];

    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 720 ? 28.0 : 18.0;
            final maxWidth =
                constraints.maxWidth >= 720 ? 720.0 : double.infinity;
            final wide = constraints.maxWidth >= 640;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 40),
                  children: [
                    const SectionPageHeader(
                      eyebrow: 'Contact',
                      title: 'Contact',
                      subtitle:
                          'Venue, contact details and attendee support for WHS Egypt 2026.',
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: WhsColors.divider),
                      ),
                      child: wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _ContactBrand(),
                                const SizedBox(width: 28),
                                Expanded(
                                  child: _ContactDetails(details: details),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                const _ContactBrand(),
                                const SizedBox(height: 22),
                                _ContactDetails(details: details),
                              ],
                            ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: WhsColors.divider),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ATTENDEE SUPPORT',
                            style: TextStyle(
                              color: WhsColors.teal,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Registration Desk',
                            style: TextStyle(
                              color: WhsColors.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'For registration and attendee inquiries, please contact the official conference team.',
                            style: TextStyle(
                              color: WhsColors.inkMuted,
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContactBrand extends StatelessWidget {
  const _ContactBrand();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 180,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: WhsColors.sand,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Image.asset(
        AppAssets.whsHero,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails({required this.details});

  final List<(String, String)> details;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: [
        for (final item in details)
          SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.$1,
                  style: const TextStyle(
                    color: WhsColors.inkMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.$2,
                  style: const TextStyle(
                    color: WhsColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
