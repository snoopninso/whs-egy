import 'package:material_ui/material_ui.dart';

import '../../data/national_agenda_data.dart';
import '../../theme/whs_theme.dart';
import '../../widgets/section_page_header.dart';
import 'agenda_detail_screen.dart';

class NationalAgendaScreen extends StatefulWidget {
  const NationalAgendaScreen({super.key});

  @override
  State<NationalAgendaScreen> createState() => _NationalAgendaScreenState();
}

class _NationalAgendaScreenState extends State<NationalAgendaScreen> {
  /// 0 = All, then category indexes + 1.
  int _selectedFilter = 0;

  String? get _selectedCategoryId {
    if (_selectedFilter == 0) return null;
    return NationalAgendaRepository.categories[_selectedFilter - 1].id;
  }

  List<AgendaItem> get _visibleItems {
    return NationalAgendaRepository.itemsForCategory(_selectedCategoryId);
  }

  void _openItem(AgendaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AgendaDetailScreen(itemId: item.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;
    final filterLabels = [
      'All',
      ...NationalAgendaRepository.categories.map((c) => c.label),
    ];

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
                        child: SectionPageHeader(
                          eyebrow: NationalAgendaRepository.introEyebrow,
                          title: NationalAgendaRepository.introTitle,
                          subtitle: NationalAgendaRepository.introBody,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          20,
                          horizontal,
                          0,
                        ),
                        child: FilterChipRow(
                          labels: filterLabels,
                          selectedIndex: _selectedFilter,
                          onSelected: (index) {
                            setState(() => _selectedFilter = index);
                          },
                        ),
                      ),
                    ),
                    if (_selectedCategoryId != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontal,
                            14,
                            horizontal,
                            0,
                          ),
                          child: Text(
                            NationalAgendaRepository.categoryById(
                                  _selectedCategoryId!,
                                )?.description ??
                                '',
                            style: const TextStyle(
                              color: WhsColors.inkMuted,
                              fontSize: 13.5,
                              height: 1.4,
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
                          10,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Agenda items',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: WhsColors.ink,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${items.length} ${items.length == 1 ? 'item' : 'items'}',
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
                    if (items.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontal),
                          child: const _AgendaEmptyState(),
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
                        sliver: SliverList.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _AgendaCard(
                              item: item,
                              onTap: () => _openItem(item),
                            );
                          },
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

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({required this.item, required this.onTap});

  final AgendaItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final category = NationalAgendaRepository.categoryById(item.categoryId);
    final accent = item.isPlaceholder ? WhsColors.inkMuted : WhsColors.burgundy;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (item.imageAsset != null)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: AspectRatio(
                    aspectRatio: 2.4,
                    child: Image.asset(
                      item.imageAsset!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            (category?.label ?? 'Agenda').toUpperCase(),
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w800,
                              fontSize: 10.5,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        if (item.isPlaceholder) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: WhsColors.teal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'PLACEHOLDER',
                              style: TextStyle(
                                color: WhsColors.teal,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: WhsColors.inkMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.5,
                        color: WhsColors.ink,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.summary,
                      style: const TextStyle(
                        color: WhsColors.inkMuted,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                    if (item.relatedSessionIds.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.event_note_rounded,
                            size: 15,
                            color: WhsColors.teal.withValues(alpha: 0.95),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.relatedSessionIds.length} linked program '
                            '${item.relatedSessionIds.length == 1 ? 'session' : 'sessions'}',
                            style: const TextStyle(
                              color: WhsColors.teal,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgendaEmptyState extends StatelessWidget {
  const _AgendaEmptyState();

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
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_outlined,
              color: WhsColors.burgundySoft,
              size: 34,
            ),
            SizedBox(height: 12),
            Text(
              'No agenda items in this category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: WhsColors.ink,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Official National Agenda materials for this filter will appear here when published.',
              textAlign: TextAlign.center,
              style: TextStyle(color: WhsColors.inkMuted, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
