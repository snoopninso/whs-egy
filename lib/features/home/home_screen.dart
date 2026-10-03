import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_assets.dart';
import '../../core/app_info.dart';
import '../../core/app_navigator.dart';
import '../../data/organization_data.dart';
import '../../theme/whs_theme.dart';

Future<void> _launchPhoneNumber(
  BuildContext context,
  String phoneNumber,
) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);
  if (!await launchUrl(uri)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the phone number.')),
      );
    }
  }
}

Future<void> _launchWhatsApp(BuildContext context, String phoneNumber) async {
  final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  final uri = Uri.parse('https://wa.me/$sanitizedNumber');
  if (!await launchUrl(uri)) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to open WhatsApp.')));
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu_rounded),
            onSelected: (value) {
              switch (value) {
                case 'partners':
                  AppNavigator.pushPartners(context);
                case 'registration':
                  AppNavigator.pushRegister(context);
                case 'contact':
                  AppNavigator.pushContact(context);
                case 'more':
                  AppNavigator.pushMore(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'partners', child: Text('Partners')),
              PopupMenuItem(value: 'registration', child: Text('Registration')),
              PopupMenuItem(value: 'contact', child: Text('Contact')),
              PopupMenuItem(value: 'more', child: Text('More')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _HeroCard(),
          const SizedBox(height: 24),
          _OfficialOrganizations(),
          const SizedBox(height: 14),
          _EventManagementSection(),
          const SizedBox(height: 24),
          _SectionTitle(kicker: 'EXPLORE', title: 'Conference sections'),
          const SizedBox(height: 8),
          _QuickAccessCard(
            icon: Icons.calendar_month_rounded,
            title: 'Program',
            onTap: () => AppNavigator.pushProgram(context),
          ),
          const Divider(height: 1, color: WhsColors.divider),
          _QuickAccessCard(
            icon: Icons.people_alt_rounded,
            title: 'Speakers',
            onTap: () => AppNavigator.pushSpeakers(context),
          ),
          const Divider(height: 1, color: WhsColors.divider),
          _QuickAccessCard(
            icon: Icons.public_rounded,
            title: 'National Agenda',
            onTap: () => AppNavigator.pushNationalAgenda(context),
          ),
          const Divider(height: 1, color: WhsColors.divider),
          _QuickAccessCard(
            icon: Icons.location_on_rounded,
            title: 'Venue',
            onTap: () => AppNavigator.pushVenue(context),
          ),
          const SizedBox(height: 24),
          _SupportSection(),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WhsColors.divider),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final logoSize = compact ? 168.0 : 156.0;
          final copy = ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: compact ? double.infinity : 440,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EGYPT WOMEN’S HEALTH SUMMIT',
                  maxLines: 2,
                  style: TextStyle(
                    color: WhsColors.teal,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    color: WhsColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'WHS Egypt\n2026',
                  style: TextStyle(
                    color: WhsColors.burgundy,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A focused platform bringing together healthcare '
                  'professionals, experts and stakeholders around '
                  'women’s health and the national agenda.',
                  style: TextStyle(
                    color: WhsColors.inkMuted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
          final logo = _HeroLogo(size: logoSize);

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: logo),
                const SizedBox(height: 20),
                copy,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: copy),
              const SizedBox(width: 22),
              logo,
            ],
          );
        },
      ),
    );
  }
}

class _HeroLogo extends StatelessWidget {
  const _HeroLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: WhsColors.ivory,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: WhsColors.sandDeep),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(AppAssets.whsHero, fit: BoxFit.cover),
      ),
    );
  }
}

class _OfficialOrganizations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authorityCards = OrganizationData.all
        .where((info) => info.id != 'science')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(
          kicker: 'OFFICIAL ORGANIZATIONS',
          title: 'Authorities',
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < authorityCards.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _OfficialCard(
            info: authorityCards[i],
            logoSize: 96,
            subtitle: switch (authorityCards[i].id) {
              'medical' => 'Ministry of Interior',
              _ => '',
            },
          ),
        ],
      ],
    );
  }
}

class _EventManagementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _OfficialCard(
      info: OrganizationData.science,
      subtitle: '',
      displayTitle: 'Event Management',
      showKicker: false,
    );
  }
}

class _OfficialCard extends StatelessWidget {
  const _OfficialCard({
    required this.info,
    required this.subtitle,
    this.logoSize = 68,
    this.displayTitle,
    this.showKicker = true,
  });

  final OrganizationInfo info;
  final String subtitle;
  final double logoSize;
  final String? displayTitle;
  final bool showKicker;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => AppNavigator.pushOrganizationDetail(context, info),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: WhsColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: logoSize,
                height: logoSize,
                padding: EdgeInsets.all(logoSize > 68 ? 4 : 7),
                decoration: BoxDecoration(
                  color: WhsColors.sand,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(info.logoAsset, fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showKicker) ...[
                      Text(
                        info.kicker,
                        style: const TextStyle(
                          color: WhsColors.teal,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      displayTitle ?? info.title,
                      style: const TextStyle(
                        color: WhsColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: WhsColors.inkMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: WhsColors.burgundy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrganizationDetailScreen extends StatelessWidget {
  const OrganizationDetailScreen({super.key, required this.info});

  final OrganizationInfo info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      appBar: AppBar(title: Text(info.title), backgroundColor: Colors.white),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: WhsColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 94,
                      height: 94,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: WhsColors.sand,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Image.asset(info.logoAsset, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    info.kicker,
                    style: const TextStyle(
                      color: WhsColors.teal,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    info.title,
                    style: const TextStyle(
                      color: WhsColors.ink,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    info.description,
                    style: const TextStyle(
                      color: WhsColors.inkMuted,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final detail in info.details) ...[
                    Text(
                      detail.$1,
                      style: const TextStyle(
                        color: WhsColors.inkMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail.$2,
                      style: const TextStyle(
                        color: WhsColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.kicker, required this.title});

  final String kicker;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kicker,
          style: const TextStyle(
            color: WhsColors.teal,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: WhsColors.ink,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: WhsColors.teal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: WhsColors.teal, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: WhsColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: WhsColors.burgundy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(kicker: 'SUPPORT', title: 'Contact the team'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () =>
                  _launchPhoneNumber(context, AppInfo.primaryPhoneNumber),
              icon: const Icon(Icons.phone_outlined),
              label: const Text('Call'),
            ),
            OutlinedButton.icon(
              onPressed: () => _launchWhatsApp(context, AppInfo.whatsappNumber),
              icon: const Icon(Icons.chat_outlined),
              label: const Text('WhatsApp'),
            ),
          ],
        ),
      ],
    );
  }
}
