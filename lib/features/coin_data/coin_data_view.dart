import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'coin_data_bloc.dart';
import 'coin_data_state.dart';

class CoinDataWidget extends StatefulWidget {
  CoinDataWidget({Key? key}) : super(key: key);

  @override
  _CoinDataWidgetState createState() => _CoinDataWidgetState();
}

class _CoinDataWidgetState extends State<CoinDataWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinDataBloc, CoinDataState>(
      builder: (context, state) {
        if (state is CoinDataLoading && state.isInitialLoad) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CoinDataError) {
          if (state.error == EspressoCashError.notFound) {
            return SizedBox();
          }
          debugPrint(
            state.message + state.error.toString(),
          );
          return SizedBox();
        }
        if (state is CoinDataLoaded) {
          return Text(
            state.coinData.description['en'],
            style: TextStyle(fontSize: 20, color: Colors.black),
          );
        }
        return Text(
          'None',
          style: TextStyle(fontSize: 20, color: Colors.black),
        );
      },
    );
  }
}
