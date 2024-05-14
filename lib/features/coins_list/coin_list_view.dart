import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      BlocProvider.of<CoinListBloc>(context, listen: false)
          .add(LoadMoreCoins());
    }
  }

  String formatMarketCap(double value) {
    if (value >= 1e12) {
      return '\$ ${(value / 1e12).toStringAsFixed(1)}T';
    } else if (value >= 1e9) {
      return '\$ ${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '\$ ${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value >= 1e3) {
      return '\$ ${(value / 1e3).toStringAsFixed(1)}K';
    } else {
      return '\$ ${value.toString()}';
    }
  }

  String formatCurrentPrice(double value, String locale) {
    final NumberFormat numberFormat = NumberFormat.currency(
      locale: locale,
      symbol: '\$ ',
      decimalDigits: 2,
    );
    return numberFormat.format(value);
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
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                expandedHeight: 70.0,
                backgroundColor: Theme.of(context).colorScheme.background,
                flexibleSpace: ListTile(
                  contentPadding: EdgeInsets.only(top: 8.0),
                  leading: Chip(
                    label: Text('#'),
                  ),
                  title: Text(
                    'Market Cap',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '24hrs',
                          style: TextStyle(fontSize: 10, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == state.cryptoData.length) {
                      return state.hasReachedMax
                          ? Container()
                          : Center(child: CircularProgressIndicator());
                    }
                    final CoinMarketMapDto coin = state.cryptoData[index];
                    return ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 3.0),
                        child: Text(
                          index.toString(),
                          style: TextStyle(height: 0.9),
                        ),
                      ),
                      minLeadingWidth: 20,
                      title: SizedBox(
                        height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(
                                      coin.image,
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          coin.symbol.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      Flexible(
                                        child: Text(
                                          coin.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      Flexible(
                                        child: Text(
                                          formatMarketCap(coin.marketCap),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: 120,
                        height: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              formatCurrentPrice(
                                coin.currentPrice,
                                Localizations.localeOf(context).toString(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${coin.priceChangePercentage_24h.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: coin.priceChangePercentage_24h > 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  coin.priceChangePercentage_24h > 0
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 12,
                                  color: coin.priceChangePercentage_24h > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () => DetailsScreen.push(context,
                          id: coin.id, name: coin.name),
                    );
                  },
                  childCount: state.hasReachedMax
                      ? state.cryptoData.length
                      : state.cryptoData.length + 1,
                ),
              ),
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}
