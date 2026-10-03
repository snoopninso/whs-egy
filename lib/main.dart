import 'package:material_ui/material_ui.dart';

import 'core/app_info.dart';
import 'core/localization/app_language.dart';
import 'features/splash/splash_screen.dart';
import 'theme/whs_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLanguage.load();
  runApp(const WHSEgyApp());
}

class WHSEgyApp extends StatelessWidget {
  const WHSEgyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.languageCode,
      builder: (context, languageCode, _) => MaterialApp(
        title: AppInfo.eventTitle,
        debugShowCheckedModeBanner: false,
        theme: WhsTheme.light,
        locale: Locale(languageCode),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const SplashScreen(),
      ),
    );
  }
}
