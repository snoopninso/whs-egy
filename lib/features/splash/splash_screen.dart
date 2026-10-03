import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core/app_assets.dart';
import '../../core/app_info.dart';
import '../../core/app_persistence.dart';
import '../../theme/whs_theme.dart';
import '../auth/login_screen.dart';
import '../home/app_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: WhsColors.divider, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final isLoggedIn = await AppPersistence.isLoggedIn();
      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppNavigationScreen()),
        );
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhsColors.ivory,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SplashLogo(asset: AppAssets.whsHero),
                    const SizedBox(width: 18),
                    _SplashLogo(asset: AppAssets.ministryLogo),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  AppInfo.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: WhsColors.burgundy,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'SUMMIT 2026',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: WhsColors.teal,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.4,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 42,
                  height: 2,
                  decoration: BoxDecoration(
                    color: WhsColors.burgundy,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppInfo.eventDates,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: WhsColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppInfo.venueName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: WhsColors.inkMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 38),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      WhsColors.burgundy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
