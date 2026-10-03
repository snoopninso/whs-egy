import 'package:material_ui/material_ui.dart';

import '../../core/app_info.dart';
import '../../data/speaker_data.dart';
import '../../theme/whs_theme.dart';
import 'speaker_avatar.dart';
import 'speaker_detail_screen.dart';

class SpeakersScreen extends StatefulWidget {
  const SpeakersScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  State<SpeakersScreen> createState() => _SpeakersScreenState();
}

class _SpeakersScreenState extends State<SpeakersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Speaker> get _visibleSpeakers => SpeakersRepository.search(_query);

  void _openSpeaker(Speaker speaker) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SpeakerDetailScreen(speakerId: speaker.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final speakers = _visibleSpeakers;
    final hasCatalog = SpeakersRepository.speakers.isNotEmpty;

    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 720 ? 28.0 : 18.0;
            final maxWidth = constraints.maxWidth >= 720
                ? 720.0
                : double.infinity;
            final crossAxisCount = constraints.maxWidth >= 600 ? 3 : 2;

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
                          8,
                          horizontal,
                          0,
                        ),
                        child: _SpeakersHeader(
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
                        child: _SpeakerSearchField(
                          controller: _searchController,
                          enabled: hasCatalog,
                          onChanged: (value) {
                            setState(() => _query = value);
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          18,
                          horizontal,
                          10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              hasCatalog ? 'Faculty' : 'Speaker directory',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: WhsColors.ink,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              hasCatalog
                                  ? '${speakers.length} ${speakers.length == 1 ? 'speaker' : 'speakers'}'
                                  : 'Awaiting official list',
                              style: const TextStyle(
                                color: WhsColors.inkMuted,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!hasCatalog)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontal),
                          child: const _SpeakersEmptyState(
                            title: 'Official speakers coming soon',
                            body: 'Confirmed speaker names, titles, affiliations, and photos will appear here once published. The directory structure is ready for the official WHS Egypt 2026 faculty list.',
                          ),
                        ),
                      )
                    else if (speakers.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontal),
                          child: const _SpeakersEmptyState(
                            title: 'No matching speakers',
                            body: 'Try another name, or clear the search to see the full speaker list.',
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          0,
                          horizontal,
                          28,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: constraints.maxWidth >= 600
                                    ? 0.78
                                    : 0.72,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final speaker = speakers[index];
                            return _SpeakerCard(
                              speaker: speaker,
                              onTap: () => _openSpeaker(speaker),
                            );
                          }, childCount: speakers.length),
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

class _SpeakersHeader extends StatelessWidget {
  const _SpeakersHeader({required this.showBackButton});

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
                  backgroundColor: WhsColors.ivory,
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
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'EXPERTS',
          style: TextStyle(
            color: WhsColors.teal,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Speakers',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: WhsColors.ink,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Meet the experts joining WHS Egypt 2026.',
          style: TextStyle(
            color: WhsColors.inkMuted,
            height: 1.4,
            fontSize: 14.5,
          ),
        ),
      ],
    );
  }
}

class _SpeakerSearchField extends StatelessWidget {
  const _SpeakerSearchField({
    required this.controller,
    required this.onChanged,
    required this.enabled,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: enabled
            ? 'Search speakers by name'
            : 'Search available when speakers are published',
        prefixIcon: const Icon(Icons.search_rounded, color: WhsColors.burgundy),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: WhsColors.ivory,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x336B1E3A)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x226B1E3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: WhsColors.teal, width: 1.4),
        ),
      ),
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  const _SpeakerCard({required this.speaker, required this.onTap});

  final Speaker speaker;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: WhsColors.ivory,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x226B1E3A)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SpeakerAvatar(speaker: speaker),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  speaker.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    color: WhsColors.ink,
                    height: 1.2,
                  ),
                ),
                if (speaker.title != null && speaker.title!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    speaker.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: WhsColors.burgundySoft,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                ],
                if (speaker.affiliation != null &&
                    speaker.affiliation!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    speaker.affiliation!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: WhsColors.inkMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeakersEmptyState extends StatelessWidget {
  const _SpeakersEmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: WhsColors.ivory,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x336B1E3A)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [WhsColors.burgundy, WhsColors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.mic_none_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: WhsColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: WhsColors.inkMuted, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
