import 'program_data.dart';

/// Official speaker profile for WHS Egypt 2026.
///
/// Populate [SpeakersData.speakers] with confirmed summit speakers only.
/// Do not invent names, titles, affiliations, or photos.
class Speaker {
  const Speaker({
    required this.id,
    required this.name,
    this.title,
    this.affiliation,
    this.bio,
    this.photoAsset,
    this.sessionIds = const [],
  });

  final String id;
  final String name;
  final String? title;
  final String? affiliation;
  final String? bio;
  final String? photoAsset;

  /// Explicit session links. Also resolved via [ProgramSession.speakerIds].
  final List<String> sessionIds;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final value = parts.first;
      return value.substring(0, value.length >= 2 ? 2 : 1).toUpperCase();
    }
    return ('${parts.first[0]}${parts.last[0]}').toUpperCase();
  }
}

/// Repository surface for speaker content.
abstract final class SpeakersRepository {
  static List<Speaker> get speakers => SpeakersData.speakers;

  static Speaker? byId(String id) {
    for (final speaker in speakers) {
      if (speaker.id == id) return speaker;
    }
    return null;
  }

  static List<Speaker> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return speakers;
    return speakers
        .where((speaker) => speaker.name.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  /// Sessions linked to a speaker from either side of the relationship.
  static List<ProgramSession> relatedSessions(Speaker speaker) {
    final bySessionLink = ProgramRepository.sessionsForSpeaker(speaker.id);
    final bySpeakerLink = <ProgramSession>[];
    for (final sessionId in speaker.sessionIds) {
      final session = ProgramRepository.sessionById(sessionId);
      if (session != null) bySpeakerLink.add(session);
    }

    final merged = <String, ProgramSession>{};
    for (final session in [...bySessionLink, ...bySpeakerLink]) {
      merged[session.id] = session;
    }
    return merged.values.toList(growable: false);
  }
}

/// Speaker catalog.
///
/// Currently empty: the Flutter project and web prototype do not contain
/// confirmed speaker names, credentials, or photo assets. Add official
/// entries here when available, for example:
///
/// ```dart
/// Speaker(
///   id: 'spk-001',
///   name: 'Official Name',
///   title: 'Official Title',
///   affiliation: 'Official Institution',
///   photoAsset: 'assets/speakers/official-photo.jpg',
///   sessionIds: ['s-opening'],
/// ),
/// ```
abstract final class SpeakersData {
  static const List<Speaker> speakers = <Speaker>[
    Speaker(id: 'spk-001', name: 'Doctor'),
    Speaker(id: 'spk-002', name: 'Doctor'),
    Speaker(id: 'spk-003', name: 'Doctor'),
  ];
}
