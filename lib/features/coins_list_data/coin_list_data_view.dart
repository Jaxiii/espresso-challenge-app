import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/coin_list_data_repository/coin_list_data_repository.dart';
import 'coin_list_data_bloc.dart';
import 'coin_list_data_event.dart';
import 'coin_list_data_state.dart';

class CryptoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This will retrieve the CryptoRepository from the provider
    final cryptoRepository = context.watch<CryptoRepository>();

    // Now you can use cryptoRepository to access data or pass it to your BLoC
    return BlocProvider(
      create: (_) => CryptoBloc(cryptoRepository)..add(FetchCryptoData()),
      child: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          if (state is CryptoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CryptoLoaded) {
            return ListView.builder(
              itemCount: state.cryptoData.length,
              itemBuilder: (context, index) {
                var coin = state.cryptoData[index];
                return ListTile(title: Text(coin.name));
              },
            );
          } else if (state is CryptoError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("Start searching for cryptocurrencies!"));
        },
      ),
    );
  }
}
