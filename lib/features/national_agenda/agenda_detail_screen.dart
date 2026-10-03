import 'package:material_ui/material_ui.dart';

import '../../core/app_info.dart';
import '../../core/app_navigator.dart';
import '../../data/national_agenda_data.dart';
import '../../data/program_data.dart';
import '../../theme/whs_theme.dart';
import '../program/session_detail_screen.dart';

class AgendaDetailScreen extends StatelessWidget {
  const AgendaDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final item = NationalAgendaRepository.itemById(itemId);

    if (item == null) {
      return Scaffold(
        backgroundColor: WhsColors.sand,
        appBar: AppBar(title: const Text('National Agenda')),
        body: const Center(child: Text('Agenda item not found.')),
      );
    }

    final category = NationalAgendaRepository.categoryById(item.categoryId);
    final sessions = NationalAgendaRepository.relatedSessions(item);
    final accent = item.isPlaceholder ? WhsColors.inkMuted : WhsColors.burgundy;

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
                            'Agenda detail',
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
                    if (item.imageAsset != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                item.imageAsset!,
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
                                      Colors.black.withValues(alpha: 0.5),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 14,
                                bottom: 14,
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
                    const SizedBox(height: 16),
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
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _MetaPill(
                                label: category?.label ?? 'Agenda',
                                color: accent,
                              ),
                              if (item.isPlaceholder)
                                const _MetaPill(
                                  label: 'Placeholder',
                                  color: WhsColors.teal,
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: WhsColors.ink,
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.summary,
                            style: const TextStyle(
                              color: WhsColors.inkMuted,
                              fontSize: 15,
                              height: 1.45,
                            ),
                          ),
                          if (item.detail != null &&
                              item.detail!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0x336B1E3A)),
                            const SizedBox(height: 14),
                            const Text(
                              'DETAILS',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800,
                                color: WhsColors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.detail!,
                              style: const TextStyle(
                                color: WhsColors.inkMuted,
                                fontSize: 14.5,
                                height: 1.45,
                              ),
                            ),
                          ],
                          if (item.stakeholders.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'STAKEHOLDERS',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800,
                                color: WhsColors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...item.stakeholders.map(
                              (name) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.apartment_rounded,
                                      size: 16,
                                      color: WhsColors.burgundy,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: WhsColors.ink,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Related program sessions',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'No linked Program sessions for this agenda item yet.',
                              style: TextStyle(
                                color: WhsColors.inkMuted,
                                height: 1.4,
                                fontSize: 13.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  AppNavigator.openProgram(context),
                              child: const Text('Browse Program'),
                            ),
                          ],
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

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.8,
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
