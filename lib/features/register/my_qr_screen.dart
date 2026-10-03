import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/app_navigator.dart';
import '../../core/app_persistence.dart';
import '../../theme/whs_theme.dart';

class MyQrScreen extends StatelessWidget {
  const MyQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      appBar: AppBar(title: const Text('My QR')),
      body: FutureBuilder<Map<String, String>?>(
        future: AppPersistence.latestRegistrationRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final token = snapshot.data?['qr_token'];
          if (token == null || token.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.qr_code_2_rounded,
                      color: WhsColors.teal,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your QR code will appear here after registration.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: WhsColors.inkMuted, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => AppNavigator.pushRegister(context),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: WhsColors.divider),
              ),
              child: QrImageView(
                data: token,
                size: 260,
                backgroundColor: Colors.white,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
            ),
          );
        },
      ),
    );
  }
}
