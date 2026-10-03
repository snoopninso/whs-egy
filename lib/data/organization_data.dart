import '../core/app_assets.dart';
import '../core/app_info.dart';

/// Official organization cards / modal copy from /app/assets/script.js.
class OrganizationInfo {
  const OrganizationInfo({
    required this.id,
    required this.kicker,
    required this.title,
    required this.description,
    required this.logoAsset,
    required this.details,
  });

  final String id;
  final String kicker;
  final String title;
  final String description;
  final String logoAsset;
  final List<(String, String)> details;
}

abstract final class OrganizationData {
  static const medical = OrganizationInfo(
    id: 'medical',
    kicker: 'OFFICIAL MEDICAL SERVICES',
    title: 'Police Medical Services',
    description: 'Police Medical Services under the Ministry of Interior and part of the official organizing authority for WHS Egypt 2026.',
    logoAsset: AppAssets.medicalServicesLogo,
    details: [
      ('ROLE', 'Official Medical Services'),
      ('AUTHORITY', 'Ministry of Interior'),
    ],
  );

  static const ministry = OrganizationInfo(
    id: 'ministry',
    kicker: 'OFFICIAL ORGANIZING AUTHORITY',
    title: 'Ministry of Interior',
    description: 'The Ministry of Interior is the official organizing authority for WHS Egypt 2026.',
    logoAsset: AppAssets.ministryLogo,
    details: [
      ('ROLE', 'Official Organizing Authority'),
      ('INITIATIVE', 'Police Medical Services'),
    ],
  );

  static const science = OrganizationInfo(
    id: 'science',
    kicker: 'EVENT MANAGEMENT',
    title: 'Science Event Management',
    description: 'The official event management company responsible for organizing and managing WHS Egypt 2026.',
    logoAsset: AppAssets.organizerLogo,
    details: [
      ('WEBSITE', AppInfo.organizerWebsite),
      ('EMAIL', AppInfo.organizerEmail),
      ('PHONE', AppInfo.organizerPhone),
      ('ADDRESS', AppInfo.organizerAddress),
    ],
  );

  static const List<OrganizationInfo> all = [ministry, medical, science];
}
