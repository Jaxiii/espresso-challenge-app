import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/coin_data/coin_data_bloc.dart';
import '../../features/coin_data/coin_data_event.dart';
import '../../features/coin_data/coin_data_view.dart';
import '../../repository/coin_repository.dart';
import '../theme.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;

  const DetailsScreen({super.key, required this.id, required this.name});

  static void push(BuildContext context,
          {required String id, required String name}) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => DetailsScreen(id: id, name: name),
        ),
      );

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CpTheme.of(context).backgroundColor,
        title: Text(widget.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocProvider<CoinDataBloc>(
                create: (_) {
                  var bloc = CoinDataBloc(context.read<CoinRepository>());
                  bloc.add(
                    FetchCoinData(id: widget.id.toLowerCase()),
                  );
                  return bloc;
                },
                child: CoinDataWidget(),
              ),
              BlocProvider<CoinDataBloc>(
                create: (_) {
                  var bloc = CoinDataBloc(context.read<CoinRepository>());
                  bloc.add(
                    FetchCoinHistoricalPrice(id: widget.id.toLowerCase()),
                  );
                  return bloc;
                },
                child: CoinChartWidget(),
              ),
              BlocProvider<CoinDataBloc>(
                create: (_) {
                  var bloc = CoinDataBloc(context.read<CoinRepository>());
                  bloc.add(
                    FetchCoinPrice(id: widget.id.toLowerCase()),
                  );
                  return bloc;
                },
                child: CoinPriceWidget(
                  id: widget.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
