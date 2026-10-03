import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_info.dart';
import '../../core/app_navigator.dart';
import '../../core/localization/app_language.dart';
import '../../core/localization/app_strings.dart';
import '../../theme/whs_theme.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  Future<void> _selectLanguage(BuildContext context, String currentCode) async {
    final code = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppStrings.get('language', languageCode: currentCode)),
        children: [
          for (final language in const [('en', 'English'), ('ar', 'العربية')])
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(language.$1),
              child: Row(
                children: [
                  Expanded(child: Text(language.$2)),
                  if (language.$1 == currentCode)
                    const Icon(Icons.check_rounded, color: WhsColors.teal),
                ],
              ),
            ),
        ],
      ),
    );
    if (code != null) await AppLanguage.setLanguageCode(code);
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final number = AppInfo.whatsappNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final opened = await launchUrl(
      Uri.parse('https://wa.me/$number'),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to open WhatsApp.')));
    }
  }

  void _showAbout(BuildContext context, String languageCode) {
    showAboutDialog(
      context: context,
      applicationName: AppInfo.appName,
      applicationVersion: '2026',
      children: [
        Text(AppInfo.eventDates),
        const SizedBox(height: 6),
        Text(AppInfo.venueName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageCode,
      builder: (context, languageCode, _) {
        String label(String key) =>
            AppStrings.get(key, languageCode: languageCode);

        return Scaffold(
          backgroundColor: WhsColors.sand,
          appBar: AppBar(title: Text(label('more'))),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
            children: [
              _MoreItem(
                icon: Icons.assignment_ind_outlined,
                title: label('myRegistration'),
                onTap: () => AppNavigator.pushMyRegistration(context),
              ),
              _MoreItem(
                icon: Icons.location_on_outlined,
                title: label('venue'),
                onTap: () => AppNavigator.pushVenue(context),
              ),
              _MoreItem(
                icon: Icons.public_outlined,
                title: label('nationalAgenda'),
                onTap: () => AppNavigator.pushNationalAgenda(context),
              ),
              _MoreItem(
                icon: Icons.notifications_none_rounded,
                title: label('notifications'),
                onTap: () => AppNavigator.pushNotifications(context),
              ),
              const Divider(height: 26),
              _MoreItem(
                icon: Icons.info_outline_rounded,
                title: label('about'),
                onTap: () => _showAbout(context, languageCode),
              ),
              _MoreItem(
                icon: Icons.handshake_outlined,
                title: label('partners'),
                onTap: () => AppNavigator.pushPartners(context),
              ),
              _MoreItem(
                icon: Icons.mail_outline_rounded,
                title: label('contact'),
                onTap: () => AppNavigator.pushContact(context),
              ),
              _MoreItem(
                icon: Icons.chat_outlined,
                title: label('whatsapp'),
                onTap: () => _openWhatsApp(context),
              ),
              _MoreItem(
                icon: Icons.language_rounded,
                title: label('language'),
                subtitle: languageCode == 'ar' ? 'العربية' : 'English',
                onTap: () => _selectLanguage(context, languageCode),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MoreItem extends StatelessWidget {
  const _MoreItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: WhsColors.teal),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
