import 'package:material_ui/material_ui.dart';

import '../../theme/whs_theme.dart';
import '../../widgets/section_page_header.dart';

/// Partners section aligned with /app partners page structure.
///
/// /app uses empty `.partner-box` placeholders; the live HTML for this page
/// is truncated on the server, and no confirmed partner names appear in /app.
/// Do not invent sponsor or partner identities.
class PartnersScreen extends StatelessWidget {
  const PartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 720 ? 28.0 : 18.0;
            final maxWidth =
                constraints.maxWidth >= 720 ? 720.0 : double.infinity;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 0),
                        child: const SectionPageHeader(
                          eyebrow: 'Partners',
                          title: 'Partners',
                          subtitle:
                              'Dedicated space for the confirmed sponsor and partner identities.',
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        24,
                        horizontal,
                        40,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth >= 720 ? 4 : 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1.15,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => const _PartnerPlaceholderBox(),
                          childCount: 8,
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

class _PartnerPlaceholderBox extends StatelessWidget {
  const _PartnerPlaceholderBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WhsColors.divider),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Partner',
        style: TextStyle(
          color: WhsColors.inkMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
