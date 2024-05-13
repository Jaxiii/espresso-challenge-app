import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/coin_data/coin_data_bloc.dart';
import '../../features/coin_data/coin_data_event.dart';
import '../../features/coin_data/coin_data_view.dart';
import '../../repository/coin_repository.dart';
import '../theme.dart';

class DetailsScreen extends StatefulWidget {
  final String title;

  const DetailsScreen({super.key, required this.title});

  static void push(BuildContext context, {required String title}) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => DetailsScreen(title: title),
        ),
      );

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CpTheme.of(context).backgroundColor,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocProvider<CoinDataBloc>(
              create: (_) {
                var bloc = CoinDataBloc(context.read<CoinRepository>());
                bloc.add(
                  FetchCoinData(id: widget.title.toLowerCase()),
                );
                return bloc;
              },
              child: CoinDataWidget(),
            ),
            Container(
              height: 200,
              width: 200,
              color: Colors.red,
            ),
            Column(
              children: [
                TextField(),
                TextField(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
