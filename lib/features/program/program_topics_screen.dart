import 'package:material_ui/material_ui.dart';

import '../../core/app_info.dart';
import '../../core/app_navigator.dart';
import '../../data/program_data.dart';
import '../../data/speaker_data.dart';
import '../../theme/whs_theme.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late String _selectedDayId;

  @override
  void initState() {
    super.initState();
    _selectedDayId = ProgramRepository.days.first.id;
  }

  List<ProgramSession> get _visibleSessions {
    final query = _searchQuery.trim().toLowerCase();
    final sessions = ProgramRepository.sessionsFor(dayId: _selectedDayId).where(
      (session) {
        if (query.isEmpty) return true;
        final track = ProgramRepository.trackById(session.trackId)?.label ?? '';
        final speakerNames = [
          ...session.speakerNames,
          ...session.speakerIds
              .map(SpeakersRepository.byId)
              .whereType<Speaker>()
              .map((speaker) => speaker.name),
        ];
        return session.title.toLowerCase().contains(query) ||
            session.summary.toLowerCase().contains(query) ||
            track.toLowerCase().contains(query) ||
            speakerNames.any((name) => name.toLowerCase().contains(query)) ||
            (session.location?.toLowerCase().contains(query) ?? false);
      },
    ).toList();
    sessions.sort(
      (first, second) => first.startTime.compareTo(second.startTime),
    );
    return sessions;
  }

  List<ProgramTopic> get _visibleTopics {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return ProgramRepository.topics;

    return ProgramRepository.topics
        .where(
          (topic) =>
              topic.title.toLowerCase().contains(query) ||
              topic.arabicTitle.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = _visibleSessions;
    final topics = _visibleTopics;
    final selectedDay = ProgramRepository.dayById(_selectedDayId);

    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 900 ? 34.0 : 18.0;
            final maxWidth = constraints.maxWidth >= 1100 ? 900.0 : 720.0;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          12,
                          horizontal,
                          0,
                        ),
                        child: _ProgramHeader(
                          showBackButton: widget.showBackButton,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          18,
                          horizontal,
                          0,
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search sessions or topics',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchQuery.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Clear search',
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: WhsColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: WhsColors.divider,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          18,
                          horizontal,
                          0,
                        ),
                        child: _ProgramDaySelector(
                          selectedDayId: _selectedDayId,
                          onSelected: (dayId) =>
                              setState(() => _selectedDayId = dayId),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          22,
                          horizontal,
                          10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'SCHEDULE',
                                    style: TextStyle(
                                      color: WhsColors.teal,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    selectedDay == null
                                        ? 'Sessions'
                                        : '${selectedDay.label} · ${selectedDay.dateLabel}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: WhsColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${sessions.length} ${sessions.length == 1 ? 'session' : 'sessions'}',
                              style: const TextStyle(
                                color: WhsColors.inkMuted,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (sessions.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontal,
                            18,
                            horizontal,
                            24,
                          ),
                          child: const Text(
                            'No scheduled sessions are available for this day or search.',
                            style: TextStyle(color: WhsColors.inkMuted),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          0,
                          horizontal,
                          12,
                        ),
                        sliver: SliverList.separated(
                          itemCount: sessions.length,
                          separatorBuilder: (_, _) => const Divider(
                            height: 1,
                            color: WhsColors.divider,
                          ),
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            return _SessionTimelineEntry(
                              session: session,
                              onTap: () => AppNavigator.pushSessionDetail(
                                context,
                                session.id,
                              ),
                            );
                          },
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          8,
                          horizontal,
                          28,
                        ),
                        child: ExpansionTile(
                          key: ValueKey('topics-$_searchQuery'),
                          initiallyExpanded: _searchQuery.isNotEmpty,
                          tilePadding: EdgeInsets.zero,
                          title: const Text(
                            'Scientific topics',
                            style: TextStyle(
                              color: WhsColors.ink,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            '${topics.length} ${topics.length == 1 ? 'topic' : 'topics'} · No day or time mapping in current data',
                            style: const TextStyle(
                              color: WhsColors.inkMuted,
                              fontSize: 12,
                            ),
                          ),
                          children: [
                            if (topics.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'No topics match your search.',
                                  style: TextStyle(color: WhsColors.inkMuted),
                                ),
                              )
                            else
                              for (final topic in topics) ...[
                                const Divider(
                                  height: 1,
                                  color: WhsColors.divider,
                                ),
                                _ProgramTopicRow(
                                  topic: topic,
                                  onTap: () => AppNavigator.pushProgramTopic(
                                    context,
                                    topic,
                                  ),
                                ),
                              ],
                          ],
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

class _ProgramHeader extends StatelessWidget {
  const _ProgramHeader({required this.showBackButton});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: WhsColors.burgundyDeep,
                ),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 8),
            ],
            const Expanded(
              child: Text(
                AppInfo.eventTitle,
                style: TextStyle(
                  color: WhsColors.burgundySoft,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'SCIENTIFIC PROGRAM',
          style: TextStyle(
            color: WhsColors.teal,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Program',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: WhsColors.ink,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Browse scheduled sessions by day, with published topics below.',
          style: TextStyle(
            color: WhsColors.inkMuted,
            height: 1.45,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ProgramDaySelector extends StatelessWidget {
  const _ProgramDaySelector({
    required this.selectedDayId,
    required this.onSelected,
  });

  final String selectedDayId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < ProgramRepository.days.length; index++) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(
            child: _ProgramDayTab(
              day: ProgramRepository.days[index],
              selected: ProgramRepository.days[index].id == selectedDayId,
              onTap: () => onSelected(ProgramRepository.days[index].id),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgramDayTab extends StatelessWidget {
  const _ProgramDayTab({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final ProgramDay day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? WhsColors.burgundyDeep : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? WhsColors.burgundyDeep : WhsColors.divider,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day.label.toUpperCase(),
                style: TextStyle(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.72)
                      : WhsColors.teal,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                day.dateLabel,
                style: TextStyle(
                  color: selected ? Colors.white : WhsColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionTimelineEntry extends StatelessWidget {
  const _SessionTimelineEntry({required this.session, required this.onTap});

  final ProgramSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final track = ProgramRepository.trackById(session.trackId);
    final accent = ProgramTrackStyle.colorFor(session.trackId);
    final speakers = [
      ...session.speakerNames,
      ...session.speakerIds
          .map(SpeakersRepository.byId)
          .whereType<Speaker>()
          .map((speaker) => speaker.name),
    ];
    final location = session.location?.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 66,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      session.timeLabel,
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 18,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        child: Container(width: 2, color: WhsColors.divider),
                      ),
                      Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (track != null) ...[
                        Text(
                          track.label.toUpperCase(),
                          style: TextStyle(
                            color: accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                      Text(
                        session.title,
                        style: const TextStyle(
                          color: WhsColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        session.summary,
                        style: const TextStyle(
                          color: WhsColors.inkMuted,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      if (speakers.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _SessionMetadata(
                          icon: Icons.mic_none_rounded,
                          text: speakers.join(', '),
                        ),
                      ],
                      if (location != null && location.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _SessionMetadata(
                          icon: Icons.place_outlined,
                          text: location,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: WhsColors.inkMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionMetadata extends StatelessWidget {
  const _SessionMetadata({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: WhsColors.inkMuted),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: WhsColors.inkMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgramTopicRow extends StatelessWidget {
  const _ProgramTopicRow({required this.topic, required this.onTap});

  final ProgramTopic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '${topic.number}.',
                  style: const TextStyle(
                    color: WhsColors.burgundy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        color: WhsColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        topic.arabicTitle,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: WhsColors.inkMuted,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: WhsColors.inkMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
