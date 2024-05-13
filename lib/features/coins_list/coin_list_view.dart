import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/screens/details_screen.dart';
import 'coin_list_bloc.dart';
import 'coin_list_event.dart';
import 'coin_list_state.dart';

class CoinListWidget extends StatefulWidget {
  CoinListWidget({Key? key}) : super(key: key);

  @override
  _CoinListWidgetState createState() => _CoinListWidgetState();
}

class _CoinListWidgetState extends State<CoinListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      BlocProvider.of<CoinListBloc>(context, listen: false)
          .add(LoadMoreCoins());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinListBloc, CoinListState>(
      builder: (context, state) {
        if (state is CoinListLoading && state.isInitialLoad) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CoinListError) {
          return Center(child: Text(state.message));
        }
        if (state is CoinListWithMarketLoaded) {
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
              return ListTile(
                title: Text(coin.name),
                onTap: () => DetailsScreen.push(context, title: coin.name),
              );
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
