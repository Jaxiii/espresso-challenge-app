import 'dart:ui';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/coins_list/coin_list_bloc.dart';
import 'repository/coin_repository.dart';
import 'services/api_wrapper.dart';
import 'ui/screens/home_screen.dart';
import 'ui/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<APIWrapper>(
          create: (_) => APIWrapper(CoinsClient(CoingeckoClient.init())),
        ),
        ProxyProvider<APIWrapper, CoinRepository>(
          update: (_, apiWrapper, __) => CoinRepository(apiWrapper),
        ),
      ],
      child: Builder(
        builder: (context) {
          final brightness = PlatformDispatcher.instance.platformBrightness;
          final themeData = brightness == Brightness.dark
              ? const CpThemeData.black()
              : const CpThemeData.light();
          return CpTheme(
            theme: themeData,
            child: MaterialApp(
              theme: themeData.toMaterialTheme(),
              darkTheme: themeData.toMaterialTheme(),
              title: 'Espresso Cash - Code Challenge',
              home: BlocProvider<CoinListBloc>(
                create: (context) =>
                    CoinListBloc(context.read<CoinRepository>()),
                child: HomeScreen(title: 'Espresso Cash - Code Challenge'),
              ),
            ),
          );
        },
      ),
    );
  }
}
