import 'package:material_ui/material_ui.dart';

import '../../core/app_navigator.dart';
import '../../core/app_persistence.dart';
import '../../theme/whs_theme.dart';

class MyRegistrationScreen extends StatelessWidget {
  const MyRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.sand,
      appBar: AppBar(title: const Text('My Registration')),
      body: FutureBuilder<Map<String, String>?>(
        future: AppPersistence.latestRegistrationRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final registration = snapshot.data;
          if (registration == null) {
            return _EmptyRegistration(
              onRegister: () => AppNavigator.pushRegister(context),
            );
          }

          const fields = [
            ('FULL NAME', 'full_name'),
            ('EMAIL', 'email'),
            ('ORGANIZATION', 'organization'),
            ('JOB TITLE', 'job_title'),
            ('PHONE', 'phone'),
            ('ATTENDANCE', 'attendance_type'),
          ];

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WhsColors.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: WhsColors.teal),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Registration Status',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      registration['qr_token']?.isNotEmpty == true
                          ? 'Submitted'
                          : 'Submitted · QR unavailable',
                      style: const TextStyle(
                        color: WhsColors.teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: WhsColors.divider),
                ),
                child: Column(
                  children: [
                    for (final field in fields)
                      if ((registration[field.$2] ?? '').isNotEmpty)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            field.$1,
                            style: const TextStyle(
                              color: WhsColors.inkMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            registration[field.$2]!,
                            style: const TextStyle(
                              color: WhsColors.ink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              if (registration['qr_token']?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => AppNavigator.pushMyQr(context),
                  icon: const Icon(Icons.qr_code_rounded),
                  label: const Text('View My QR'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EmptyRegistration extends StatelessWidget {
  const _EmptyRegistration({required this.onRegister});

  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_ind_outlined,
              color: WhsColors.teal,
              size: 44,
            ),
            const SizedBox(height: 12),
            const Text(
              'No registration found',
              style: TextStyle(
                color: WhsColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Submit a registration request to see your details and status here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: WhsColors.inkMuted, height: 1.4),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRegister, child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
