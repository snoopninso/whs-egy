import 'package:material_ui/material_ui.dart';

import '../theme/whs_theme.dart';

/// Scientific track / session category from the WHS program.
class ProgramTrack {
  const ProgramTrack({required this.id, required this.label});

  final String id;
  final String label;
}

/// A conference day within the WHS Egypt 2026 program.
class ProgramDay {
  const ProgramDay({
    required this.id,
    required this.label,
    required this.dateLabel,
    required this.dateIso,
  });

  final String id;
  final String label;
  final String dateLabel;
  final String dateIso;
}

/// A single program session / topic.
class ProgramSession {
  const ProgramSession({
    required this.id,
    required this.dayId,
    required this.trackId,
    required this.title,
    required this.summary,
    required this.startTime,
    this.endTime,
    this.speakerIds = const [],
    this.speakerNames = const [],
    this.location,
    this.imageAsset,
  });

  final String id;
  final String dayId;
  final String trackId;
  final String title;
  final String summary;
  final String startTime;
  final String? endTime;

  /// Linked speaker IDs once official speaker data is published.
  final List<String> speakerIds;
  final List<String> speakerNames;
  final String? location;
  final String? imageAsset;

  String get timeLabel {
    if (endTime == null || endTime!.isEmpty) return startTime;
    return '$startTime – $endTime';
  }
}

/// A bilingual scientific topic. Fill optional fields when details are ready.
class ProgramTopic {
  const ProgramTopic({
    required this.number,
    required this.title,
    required this.arabicTitle,
    this.description = '',
    this.arabicDescription = '',
    this.date = '',
    this.time = '',
    this.location = '',
    this.speakers = const [],
  });

  final int number;
  final String title;
  final String arabicTitle;
  final String description;
  final String arabicDescription;
  final String date;
  final String time;
  final String location;
  final List<String> speakers;
}

/// Repository surface for program content (swapable to remote/JSON later).
abstract final class ProgramRepository {
  static List<ProgramDay> get days => ProgramData.days;

  static List<ProgramTrack> get tracks => ProgramData.tracks;

  static List<ProgramSession> get sessions => ProgramData.sessions;

  static List<ProgramTopic> get topics => ProgramData.topics;

  static ProgramTrack? trackById(String id) {
    for (final track in tracks) {
      if (track.id == id) return track;
    }
    return null;
  }

  static ProgramDay? dayById(String id) {
    for (final day in days) {
      if (day.id == id) return day;
    }
    return null;
  }

  static ProgramSession? sessionById(String id) {
    for (final session in sessions) {
      if (session.id == id) return session;
    }
    return null;
  }

  static List<ProgramSession> sessionsFor({String? dayId, String? trackId}) {
    return sessions
        .where((session) {
          final dayOk = dayId == null || session.dayId == dayId;
          final trackOk = trackId == null || session.trackId == trackId;
          return dayOk && trackOk;
        })
        .toList(growable: false);
  }

  static List<ProgramSession> sessionsForSpeaker(String speakerId) {
    return sessions
        .where((session) => session.speakerIds.contains(speakerId))
        .toList(growable: false);
  }
}

/// Schedule details and scientific topics for WHS Egypt 2026.
abstract final class ProgramData {
  static const List<ProgramDay> days = [
    ProgramDay(
      id: 'day-01',
      label: 'Day 01',
      dateLabel: '05 October',
      dateIso: '2026-10-05',
    ),
    ProgramDay(
      id: 'day-02',
      label: 'Day 02',
      dateLabel: '06 October',
      dateIso: '2026-10-06',
    ),
  ];

  static const List<ProgramTrack> tracks = [
    ProgramTrack(id: 'opening', label: 'Opening'),
    ProgramTrack(id: 'scientific', label: 'Scientific Session'),
    ProgramTrack(id: 'expert-panel', label: 'Expert Panel'),
  ];

  static const List<ProgramTopic> topics = [
    ProgramTopic(
      number: 1,
      title: 'Women’s Health Screening',
      arabicTitle: 'الفحص والكشف المبكر لصحة المرأة',
    ),
    ProgramTopic(
      number: 2,
      title: 'Cervical Cancer Screening – National Perspective',
      arabicTitle: 'الكشف المبكر لسرطان عنق الرحم – منظور قومي',
    ),
    ProgramTopic(
      number: 3,
      title: 'Female Morbidity and Mortality in Egypt',
      arabicTitle: 'معدلات المرض والوفيات بين النساء في مصر',
    ),
    ProgramTopic(
      number: 4,
      title: 'Violence Against Women',
      arabicTitle: 'العنف ضد المرأة',
    ),
    ProgramTopic(
      number: 5,
      title: 'Cancers in Women in Egypt',
      arabicTitle: 'الأورام السرطانية لدى النساء في مصر',
    ),
    ProgramTopic(
      number: 6,
      title: 'Breast & Gynecological Cancers – National Perspective',
      arabicTitle: 'سرطانات الثدي وأورام النساء – منظور قومي',
    ),
    ProgramTopic(
      number: 7,
      title: 'Safe Motherhood',
      arabicTitle: 'الأمومة الآمنة',
    ),
    ProgramTopic(
      number: 8,
      title: 'Safe Childbirth',
      arabicTitle: 'الولادة الآمنة',
    ),
    ProgramTopic(
      number: 9,
      title: 'Cardiovascular Diseases in Women',
      arabicTitle: 'أمراض القلب والأوعية الدموية لدى النساء',
    ),
    ProgramTopic(
      number: 10,
      title: 'Quality Assurance in Women’s Health',
      arabicTitle: 'ضمان الجودة في خدمات صحة المرأة',
    ),
    ProgramTopic(
      number: 11,
      title: 'Nursing Care in Women’s Health',
      arabicTitle: 'الرعاية التمريضية لصحة المرأة',
    ),
    ProgramTopic(
      number: 12,
      title: 'Sexual Health in Egypt',
      arabicTitle: 'الصحة الجنسية في مصر',
    ),
    ProgramTopic(
      number: 13,
      title: 'Family Planning',
      arabicTitle: 'تنظيم الأسرة',
    ),
    ProgramTopic(
      number: 14,
      title: 'Women’s Mental Health in Egypt',
      arabicTitle: 'الصحة النفسية للمرأة في مصر',
    ),
    ProgramTopic(
      number: 15,
      title: 'Women’s Health Public Awareness',
      arabicTitle: 'التوعية الصحية للمرأة',
    ),
    ProgramTopic(
      number: 16,
      title: 'Obesity in Women in Egypt',
      arabicTitle: 'السمنة لدى النساء في مصر',
    ),
    ProgramTopic(
      number: 17,
      title: 'Nutrition & Lifestyle Medicine in Women',
      arabicTitle: 'التغذية وطب نمط الحياة لدى النساء',
    ),
    ProgramTopic(
      number: 18,
      title: 'Diabetes in Women in Egypt',
      arabicTitle: 'مرض السكري لدى النساء في مصر',
    ),
    ProgramTopic(
      number: 19,
      title: 'Radiology & Medical Imaging',
      arabicTitle: 'الأشعة والتصوير الطبي',
    ),
    ProgramTopic(
      number: 20,
      title: 'Women’s Health – Clinical Pharmacy Perspective',
      arabicTitle: 'صحة المرأة من منظور الصيدلة الإكلينيكية',
    ),
    ProgramTopic(
      number: 21,
      title: 'Physical Therapy in Women’s Health',
      arabicTitle: 'العلاج الطبيعي في مجال صحة المرأة',
    ),
  ];

  static const List<ProgramSession> sessions = [
    ProgramSession(
      id: 's-opening',
      dayId: 'day-01',
      trackId: 'opening',
      title: 'Opening Session',
      summary: 'Welcome & Summit Opening',
      startTime: '09:00',
      imageAsset: 'assets/logo/h logo.jpeg',
    ),
    ProgramSession(
      id: 's-womens-health',
      dayId: 'day-01',
      trackId: 'scientific',
      title: 'Women’s Health in Focus',
      summary: 'Key scientific topics and expert discussions.',
      startTime: '10:30',
      imageAsset: 'assets/logo/h logo.jpeg',
    ),
    ProgramSession(
      id: 's-national-priorities',
      dayId: 'day-01',
      trackId: 'expert-panel',
      title: 'National Priorities & Practice',
      summary: 'Discussion around national priorities and clinical practice.',
      startTime: '12:30',
      imageAsset: 'assets/logo/p midcal.jpeg',
    ),
  ];
}

/// Visual accent helpers for program tracks.
abstract final class ProgramTrackStyle {
  static Color colorFor(String trackId) {
    switch (trackId) {
      case 'opening':
        return WhsColors.burgundy;
      case 'scientific':
        return WhsColors.teal;
      case 'expert-panel':
        return WhsColors.burgundySoft;
      default:
        return WhsColors.inkMuted;
    }
  }

  static IconData iconFor(String trackId) {
    switch (trackId) {
      case 'opening':
        return Icons.flag_rounded;
      case 'scientific':
        return Icons.biotech_rounded;
      case 'expert-panel':
        return Icons.groups_rounded;
      default:
        return Icons.event_note_rounded;
    }
  }
}
