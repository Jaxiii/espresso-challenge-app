import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
//import 'package:espresso_challange/ui/splash_screen.dart';
import 'ui/screens/splash_screen.dart';

void main() async {
  if (!const bool.hasEnvironment('API_KEY')) {
    print('API_KEY not found');
  }
  runApp(const SplashScreen());

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future.delayed(const Duration(milliseconds: 1500)).then((_) {
    runApp(const App());
  });
}
