import 'package:material_ui/material_ui.dart';

/// Navigation entry points reserved for future Home sections.
/// Labels match /app sidebar: Home, Program, Speakers, National Agenda,
/// Partners, Venue, Registration, Contact.
class HomeNavItem {
  const HomeNavItem({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
}

const List<HomeNavItem> kHomeNavItems = [
  HomeNavItem(
    id: 'program',
    label: 'Program',
    subtitle: 'Sessions & tracks',
    icon: Icons.calendar_month_rounded,
  ),
  HomeNavItem(
    id: 'speakers',
    label: 'Speakers',
    subtitle: 'Keynote leaders',
    icon: Icons.mic_none_rounded,
  ),
  HomeNavItem(
    id: 'national-agenda',
    label: 'National Agenda',
    subtitle: 'Priorities & focus',
    icon: Icons.account_balance_outlined,
  ),
  HomeNavItem(
    id: 'partners',
    label: 'Partners',
    subtitle: 'Official network',
    icon: Icons.handshake_outlined,
  ),
  HomeNavItem(
    id: 'venue',
    label: 'Venue',
    subtitle: 'Location & map',
    icon: Icons.location_on_outlined,
  ),
  HomeNavItem(
    id: 'register',
    label: 'Registration',
    subtitle: 'Join the summit',
    icon: Icons.how_to_reg_rounded,
  ),
  HomeNavItem(
    id: 'contact',
    label: 'Contact',
    subtitle: 'Support & venue',
    icon: Icons.mail_outline_rounded,
  ),
];
