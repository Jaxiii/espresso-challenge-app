import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/coins_list_data/coin_list_data_bloc.dart';
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
            home: BlocProvider<CryptoBloc>(
              create: (context) => CryptoBloc(context.read<CryptoRepository>()),
              child: HomeScreen(title: 'Espresso Cash - Code Challenge'),
            ),
          ),
        ),
      ),
    );
  }
}
