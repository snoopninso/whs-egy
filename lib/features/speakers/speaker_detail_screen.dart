import 'package:material_ui/material_ui.dart';

import '../../core/app_info.dart';
import '../../core/app_navigator.dart';
import '../../data/program_data.dart';
import '../../data/speaker_data.dart';
import '../../theme/whs_theme.dart';
import '../program/session_detail_screen.dart';
import 'speaker_avatar.dart';

class SpeakerDetailScreen extends StatelessWidget {
  const SpeakerDetailScreen({super.key, required this.speakerId});

  final String speakerId;

  @override
  Widget build(BuildContext context) {
    final speaker = SpeakersRepository.byId(speakerId);

    if (speaker == null) {
      return Scaffold(
        backgroundColor: WhsColors.sand,
        appBar: AppBar(title: const Text('Speaker')),
        body: const Center(child: Text('Speaker profile not found.')),
      );
    }

    final sessions = SpeakersRepository.relatedSessions(speaker);

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
                            'Speaker profile',
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: WhsColors.ivory,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x226B1E3A)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: SpeakerAvatar(
                              speaker: speaker,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            speaker.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: WhsColors.ink,
                              letterSpacing: -0.3,
                            ),
                          ),
                          if (speaker.title != null &&
                              speaker.title!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              speaker.title!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: WhsColors.burgundySoft,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                              ),
                            ),
                          ],
                          if (speaker.affiliation != null &&
                              speaker.affiliation!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              speaker.affiliation!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: WhsColors.inkMuted,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            AppInfo.eventTitle,
                            style: TextStyle(
                              color: WhsColors.teal.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (speaker.bio != null && speaker.bio!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: WhsColors.ivory,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0x226B1E3A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ABOUT',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800,
                                color: WhsColors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              speaker.bio!,
                              style: const TextStyle(
                                color: WhsColors.inkMuted,
                                height: 1.45,
                                fontSize: 14.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    const Text(
                      'Related sessions',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: WhsColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (sessions.isEmpty)
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
                        child: const Text(
                          'No linked program sessions yet. Related sessions will appear here when speaker–session relationships are published.',
                          style: TextStyle(
                            color: WhsColors.inkMuted,
                            height: 1.4,
                            fontSize: 13.5,
                          ),
                        ),
                      )
                    else
                      ...sessions.map(
                        (session) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RelatedSessionTile(
                            session: session,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => SessionDetailScreen(
                                    sessionId: session.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => AppNavigator.openProgram(context),
                      child: const Text('Browse full Program'),
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

class _RelatedSessionTile extends StatelessWidget {
  const _RelatedSessionTile({required this.session, required this.onTap});

  final ProgramSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final track = ProgramRepository.trackById(session.trackId);
    final accent = ProgramTrackStyle.colorFor(session.trackId);

    return Material(
      color: WhsColors.ivory,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x226B1E3A)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  session.startTime,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (track?.label ?? 'Session').toUpperCase(),
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 10.5,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      session.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: WhsColors.ink,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: WhsColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
