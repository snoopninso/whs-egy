import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../theme/whs_theme.dart';

class RegisteredUserQrDialog extends StatelessWidget {
  const RegisteredUserQrDialog({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your registration QR code'),
      content: SizedBox(
        width: 240,
        child: QrImageView(
          data: token,
          size: 220,
          backgroundColor: Colors.white,
          errorCorrectionLevel: QrErrorCorrectLevel.M,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
      titleTextStyle: const TextStyle(
        color: WhsColors.ink,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
