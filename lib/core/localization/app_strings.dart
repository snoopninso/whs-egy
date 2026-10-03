class AppStrings {
  const AppStrings._();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'World Health Summit Egypt',
      'home': 'Home',
      'program': 'Program',
      'speakers': 'Speakers',
      'myQr': 'My QR',
      'more': 'More',
      'myRegistration': 'My Registration',
      'nationalAgenda': 'National Agenda',
      'venue': 'Venue',
      'register': 'Register',
      'partners': 'Partners',
      'updates': 'Updates',
      'notifications': 'Notifications',
      'about': 'About',
      'contact': 'Contact',
      'whatsapp': 'WhatsApp',
      'language': 'Language',
      'registrationStatus': 'Registration Status',
      'submitted': 'Submitted',
      'notRegistered': 'Not registered',
      'retry': 'Retry',
      'connectionLost': 'Connection Lost',
      'connectionLostMsg':
          'Please check your internet connection and try again.',
    },
    'ar': {
      'appTitle': 'القمة العالمية للصحة - مصر',
      'home': 'الرئيسية',
      'program': 'البرنامج',
      'speakers': 'المتحدثون',
      'myQr': 'رمز QR الخاص بي',
      'more': 'المزيد',
      'myRegistration': 'تسجيلي',
      'nationalAgenda': 'الأجندة الوطنية',
      'venue': 'الموقع',
      'register': 'التسجيل',
      'partners': 'الشركاء والرعاة',
      'updates': 'التحديثات',
      'notifications': 'الإشعارات',
      'about': 'عن المؤتمر',
      'contact': 'اتصل بنا',
      'whatsapp': 'واتساب',
      'language': 'اللغة',
      'registrationStatus': 'حالة التسجيل',
      'submitted': 'تم الإرسال',
      'notRegistered': 'غير مسجل',
      'retry': 'إعادة المحاولة',
      'connectionLost': 'لا يوجد اتصال بالإنترنت',
      'connectionLostMsg':
          'يرجى التحقق من الاتصال بالإنترنت والمحاولة مرة أخرى.',
    },
  };

  static String get(String key, {String languageCode = 'en'}) {
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}
