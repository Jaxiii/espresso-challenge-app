import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repository/coin_list_data_repository/coin_list_data_repository.dart';
import 'services/api_wrapper.dart';
import 'ui/screens/home_screen.dart';
import 'ui/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CpTheme(
      theme: const CpThemeData.light(),
      child: Builder(
        builder: (context) => MultiProvider(
          providers: [
            Provider<APIWrapper>(
              create: (_) => APIWrapper(CoinsClient(CoingeckoClient.init())),
            ),
            ProxyProvider<APIWrapper, CryptoRepository>(
              update: (_, apiWrapper, __) => CryptoRepository(apiWrapper),
            ),
          ],
          child: MaterialApp(
            title: 'Espresso Cash - Code Challenge',
            theme: context.watch<CpThemeData>().toMaterialTheme(),
            home: const HomeScreen(title: 'Espresso Cash - Code Challenge'),
          ),
        ),
      ),
    );
  }
}
