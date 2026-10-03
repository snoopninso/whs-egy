import 'package:material_ui/material_ui.dart';

import '../../core/localization/app_language.dart';
import '../../core/localization/app_strings.dart';
import '../../features/program/program_topics_screen.dart';
import '../../features/register/my_qr_screen.dart';
import '../../features/speakers/speakers_screen.dart';
import 'home_screen.dart';
import 'more_screen.dart';

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> {
  int _selectedIndex = 0;
  Key _qrScreenKey = UniqueKey();

  void _selectDestination(int index) {
    if (index == 3) _qrScreenKey = UniqueKey();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageCode,
      builder: (context, languageCode, _) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              const HomeScreen(),
              const ProgramScreen(showBackButton: false),
              const SpeakersScreen(showBackButton: false),
              MyQrScreen(key: _qrScreenKey),
              const MoreScreen(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectDestination,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: AppStrings.get('home', languageCode: languageCode),
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_month_outlined),
                selectedIcon: const Icon(Icons.calendar_month_rounded),
                label: AppStrings.get('program', languageCode: languageCode),
              ),
              NavigationDestination(
                icon: const Icon(Icons.groups_outlined),
                selectedIcon: const Icon(Icons.groups_rounded),
                label: AppStrings.get('speakers', languageCode: languageCode),
              ),
              NavigationDestination(
                icon: const Icon(Icons.qr_code_2_rounded),
                label: AppStrings.get('myQr', languageCode: languageCode),
              ),
              NavigationDestination(
                icon: const Icon(Icons.menu_rounded),
                label: AppStrings.get('more', languageCode: languageCode),
              ),
            ],
          ),
        );
      },
    );
  }
}
