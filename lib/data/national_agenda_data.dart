import '../core/app_assets.dart';
import '../core/app_info.dart';
import 'program_data.dart';

/// High-level grouping for National Agenda content.
class AgendaCategory {
  const AgendaCategory({
    required this.id,
    required this.label,
    required this.description,
  });

  final String id;
  final String label;
  final String description;
}

/// A National Agenda topic, priority, or stakeholder entry.
class AgendaItem {
  const AgendaItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.summary,
    this.detail,
    this.stakeholders = const [],
    this.relatedSessionIds = const [],
    this.imageAsset,
    this.isPlaceholder = false,
  });

  final String id;
  final String categoryId;
  final String title;
  final String summary;
  final String? detail;
  final List<String> stakeholders;
  final List<String> relatedSessionIds;
  final String? imageAsset;
  final bool isPlaceholder;
}

/// Repository surface for National Agenda content.
abstract final class NationalAgendaRepository {
  static String get introEyebrow => NationalAgendaData.introEyebrow;
  static String get introTitle => NationalAgendaData.introTitle;
  static String get introBody => NationalAgendaData.introBody;

  static List<AgendaCategory> get categories => NationalAgendaData.categories;
  static List<AgendaItem> get items => NationalAgendaData.items;

  static AgendaCategory? categoryById(String id) {
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  static AgendaItem? itemById(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static List<AgendaItem> itemsForCategory(String? categoryId) {
    if (categoryId == null) return items;
    return items
        .where((item) => item.categoryId == categoryId)
        .toList(growable: false);
  }

  static List<ProgramSession> relatedSessions(AgendaItem item) {
    final sessions = <ProgramSession>[];
    for (final sessionId in item.relatedSessionIds) {
      final session = ProgramRepository.sessionById(sessionId);
      if (session != null) sessions.add(session);
    }
    return sessions;
  }
}

/// National Agenda content for WHS Egypt 2026.
///
/// Sourced only from existing project/prototype framing and already-published
/// Program/Home branding. No invented government policies or statistics.
abstract final class NationalAgendaData {
  static const String introEyebrow = 'NATIONAL FOCUS';
  static const String introTitle = 'National Agenda';
  static const String introBody =
      'Explore the key agenda and priorities connecting women’s health '
      'with the broader national agenda at WHS Egypt 2026.';

  static const List<AgendaCategory> categories = [
    AgendaCategory(
      id: 'priorities',
      label: 'Priorities',
      description:
          'Summit focus areas drawn from the published scientific program.',
    ),
    AgendaCategory(
      id: 'stakeholders',
      label: 'Stakeholders',
      description: 'Official organizations already recognized in the WHS Egypt branding.',
    ),
    AgendaCategory(
      id: 'forthcoming',
      label: 'Forthcoming',
      description:
          'Reserved for additional official National Agenda materials.',
    ),
  ];

  static const List<AgendaItem> items = [
    AgendaItem(
      id: 'na-national-priorities',
      categoryId: 'priorities',
      title: 'National Priorities & Practice',
      summary: 'Discussion around national priorities and clinical practice.',
      detail:
          'This agenda focus is linked directly to the published Program '
          'session of the same title. Additional official National Agenda '
          'detail will appear here when provided.',
      relatedSessionIds: ['s-national-priorities'],
      imageAsset: AppAssets.medicalServicesLogo,
    ),
    AgendaItem(
      id: 'na-womens-health-focus',
      categoryId: 'priorities',
      title: 'Women’s Health in Focus',
      summary: 'Key scientific topics and expert discussions.',
      detail:
          'Drawn from the published Program scientific session. Official '
          'National Agenda expansions for this focus will be added when available.',
      relatedSessionIds: ['s-womens-health'],
      imageAsset: AppAssets.whsHero,
    ),
    AgendaItem(
      id: 'na-ministry',
      categoryId: 'stakeholders',
      title: AppInfo.authorityName,
      summary: 'Official organizing authority recognized for WHS Egypt 2026.',
      detail:
          'The Egyptian Ministry of Interior is presented here as already '
          'established in the summit branding and Home patronage section.',
      stakeholders: [AppInfo.authorityName],
      imageAsset: AppAssets.ministryLogo,
    ),
    AgendaItem(
      id: 'na-medical-services',
      categoryId: 'stakeholders',
      title: AppInfo.medicalSectorName,
      summary: 'Official medical services partner within the summit branding.',
      detail:
          'The Medical Services Sector appears here based on existing WHS '
          'Egypt branding assets and Home patronage content.',
      stakeholders: [AppInfo.medicalSectorName, AppInfo.authorityName],
      imageAsset: AppAssets.medicalServicesLogo,
    ),
    AgendaItem(
      id: 'na-placeholder-official',
      categoryId: 'forthcoming',
      title: 'Official agenda materials',
      summary: 'Placeholder for additional confirmed National Agenda topics.',
      detail:
          'Insert official initiatives, policies, and supporting materials '
          'here when provided by the organizing authority. This entry is a '
          'structural placeholder only.',
      isPlaceholder: true,
    ),
  ];
}
