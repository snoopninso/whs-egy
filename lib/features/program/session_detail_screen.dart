import 'package:material_ui/material_ui.dart';

import '../../core/app_info.dart';
import '../../core/app_navigator.dart';
import '../../data/program_data.dart';
import '../../data/speaker_data.dart';
import '../../theme/whs_theme.dart';
import '../speakers/speaker_detail_screen.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final session = ProgramRepository.sessionById(sessionId);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session')),
        body: const Center(child: Text('Session not found.')),
      );
    }

    final track = ProgramRepository.trackById(session.trackId);
    final day = ProgramRepository.dayById(session.dayId);
    final accent = ProgramTrackStyle.colorFor(session.trackId);
    final linkedSpeakers = session.speakerIds
        .map(SpeakersRepository.byId)
        .whereType<Speaker>()
        .toList(growable: false);
    final hasSpeakerInfo =
        linkedSpeakers.isNotEmpty || session.speakerNames.isNotEmpty;

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
                  padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 32),
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: IconButton.styleFrom(
                            backgroundColor: WhsColors.ivory,
                            foregroundColor: WhsColors.burgundyDeep,
                          ),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Session details',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: WhsColors.ink,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (session.imageAsset != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                session.imageAsset!,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.05),
                                      Colors.black.withValues(alpha: 0.55),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 14,
                                bottom: 14,
                                right: 14,
                                child: Text(
                                  AppInfo.eventTitle,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: WhsColors.ivory,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x226B1E3A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  ProgramTrackStyle.iconFor(session.trackId),
                                  size: 14,
                                  color: accent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  (track?.label ?? 'Session').toUpperCase(),
                                  style: TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            session.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: WhsColors.ink,
                              height: 1.2,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            session.summary,
                            style: const TextStyle(
                              color: WhsColors.inkMuted,
                              fontSize: 15,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Divider(height: 1, color: Color(0x336B1E3A)),
                          const SizedBox(height: 16),
                          _DetailMeta(
                            icon: Icons.schedule_rounded,
                            label: 'Time',
                            value: session.timeLabel,
                          ),
                          if (day != null) ...[
                            const SizedBox(height: 12),
                            _DetailMeta(
                              icon: Icons.event_rounded,
                              label: 'Date',
                              value: '${day.label} · ${day.dateLabel} 2026',
                            ),
                          ],
                          if (session.location != null) ...[
                            const SizedBox(height: 12),
                            _DetailMeta(
                              icon: Icons.place_outlined,
                              label: 'Location',
                              value: session.location!,
                            ),
                          ],
                          if (session.speakerNames.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _DetailMeta(
                              icon: Icons.mic_none_rounded,
                              label: 'Speakers',
                              value: session.speakerNames.join(', '),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (linkedSpeakers.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Speakers',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: WhsColors.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...linkedSpeakers.map(
                        (speaker) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => SpeakerDetailScreen(
                                    speakerId: speaker.id,
                                  ),
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: Color(0x226B1E3A)),
                            ),
                            tileColor: WhsColors.ivory,
                            title: Text(
                              speaker.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: speaker.title == null
                                ? null
                                : Text(speaker.title!),
                            trailing: const Icon(Icons.chevron_right_rounded),
                          ),
                        ),
                      ),
                    ] else if (!hasSpeakerInfo) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: WhsColors.teal.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: WhsColors.teal.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Speaker details for this session will appear here when published in the Speakers section.',
                              style: TextStyle(
                                color: WhsColors.inkMuted,
                                height: 1.4,
                                fontSize: 13.5,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () =>
                                    AppNavigator.openSpeakers(context),
                                child: const Text('Open Speakers'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _DetailMeta extends StatelessWidget {
  const _DetailMeta({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: WhsColors.burgundy.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: WhsColors.burgundy),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w800,
                  color: WhsColors.burgundySoft,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: WhsColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
