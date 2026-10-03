import 'package:material_ui/material_ui.dart';

import '../../data/speaker_data.dart';
import '../../theme/whs_theme.dart';

/// Shared avatar used by list and detail screens.
class SpeakerAvatar extends StatelessWidget {
  const SpeakerAvatar({super.key, required this.speaker, this.borderRadius});

  final Speaker speaker;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(14);

    if (speaker.photoAsset != null && speaker.photoAsset!.isNotEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          speaker.photoAsset!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, _, _) =>
              _InitialsPlate(initials: speaker.initials, borderRadius: radius),
        ),
      );
    }

    return _InitialsPlate(initials: speaker.initials, borderRadius: radius);
  }
}

class _InitialsPlate extends StatelessWidget {
  const _InitialsPlate({required this.initials, required this.borderRadius});

  final String initials;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [WhsColors.burgundyDeep, WhsColors.teal],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 28,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
