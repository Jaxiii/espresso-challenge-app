import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/home.dart';
import 'ui/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CpTheme(
      theme: const CpThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Espresso Cash - Code Challenge',
          theme: context.watch<CpThemeData>().toMaterialTheme(),
          home: const HomeScreen(title: 'Espresso Cash - Code Challenge'),
        ),
      ),
    );
  }
}
