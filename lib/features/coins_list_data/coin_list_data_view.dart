import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'coin_list_data_bloc.dart';
import 'coin_list_data_event.dart';
import 'coin_list_data_state.dart';

class CryptoScreen extends StatefulWidget {
  CryptoScreen({Key? key}) : super(key: key);

  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      BlocProvider.of<CryptoBloc>(context, listen: false).add(LoadMoreCoins());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CryptoBloc, CryptoState>(
      builder: (context, state) {
        if (state is CryptoLoading && state.isInitialLoad) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CryptoError) {
          return Center(child: Text(state.message));
        }
        if (state is CryptoLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.cryptoData.length
                : state.cryptoData.length + 1,
            itemBuilder: (context, index) {
              if (index == state.cryptoData.length) {
                return state.hasReachedMax
                    ? Container()
                    : Center(child: CircularProgressIndicator());
              }
              var coin = state.cryptoData[index];
              return ListTile(title: Text(coin.name));
            },
          );
        }
        return SizedBox();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
