import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_info.dart';
import '../../theme/whs_theme.dart';
import '../../widgets/section_page_header.dart';

Future<void> _openVenueInMaps(BuildContext context) async {
  final uri = Uri.parse(AppInfo.venueMapUrl);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
      context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open the venue map.')),
    );
  }
}

/// Venue page aligned with /app venue-card layout.
class VenueScreen extends StatelessWidget {
  const VenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 720 ? 28.0 : 18.0;
            final maxWidth = constraints.maxWidth >= 720
                ? 720.0
                : double.infinity;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 40),
                  children: [
                    const SectionPageHeader(
                      eyebrow: 'Venue',
                      title: 'Venue',
                      subtitle: 'Cairo Marriott Hotel and event details.',
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: WhsColors.divider),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6EAEE),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: WhsColors.burgundy,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VENUE',
                                  style: TextStyle(
                                    color: WhsColors.teal,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  AppInfo.venueName,
                                  style: TextStyle(
                                    color: WhsColors.ink,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  AppInfo.venueAddress,
                                  style: TextStyle(
                                    color: WhsColors.inkMuted,
                                    fontSize: 13,
                                    height: 1.45,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  AppInfo.eventDates,
                                  style: TextStyle(
                                    color: WhsColors.burgundy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.place_outlined,
                            color: WhsColors.teal,
                            size: 26,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LOCATION',
                                  style: TextStyle(
                                    color: WhsColors.teal,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  AppInfo.venueLocationLabel,
                                  style: TextStyle(
                                    color: WhsColors.ink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  AppInfo.venueName,
                                  style: TextStyle(
                                    color: WhsColors.inkMuted,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _openVenueInMaps(context),
                                    icon: const Icon(Icons.map_outlined),
                                    label: const Text('Open in Google Maps'),
                                  ),
                                ),
                              ],
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
