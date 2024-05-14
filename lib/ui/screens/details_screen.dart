import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../features/coin_data/coin_data_bloc.dart';
import '../../features/coin_data/coin_data_event.dart';
import '../../features/coin_data/coin_data_view.dart';
import '../../repository/coin_repository.dart';
import '../theme.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;
  final String symbol;
  final int? rank;
  final double? price;
  final double? marketCap;
  final double? priceChange24h;
  final String? imageUrl;

  const DetailsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.symbol,
    this.rank,
    this.price,
    this.marketCap,
    this.priceChange24h,
    this.imageUrl,
  });

  static void push(
    BuildContext context, {
    required String id,
    required String name,
    required String symbol,
    int? rank,
    double? price,
    double? marketCap,
    double? priceChange24h,
    String? imageUrl,
  }) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => DetailsScreen(
            id: id,
            name: name,
            symbol: symbol,
            rank: rank,
            price: price,
            marketCap: marketCap,
            priceChange24h: priceChange24h,
            imageUrl: imageUrl,
          ),
        ),
      );

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CpTheme.of(context).backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.imageUrl ?? '',
              width: 24,
              height: 24,
            ),
            SizedBox(width: 8.0),
            Text(widget.symbol.toUpperCase()),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, size: 26),
          ),
          IconButton(
            icon: Icon(
              Icons.star_border_rounded,
              size: 26,
            ),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Platform.isAndroid ? Icons.share : Icons.ios_share_outlined,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: Theme.of(context).textTheme.headlineSmall!,
                      ),
                      SizedBox(width: 8.0),
                      SizedBox(
                        height: 24.0,
                        width:
                            24 + (8.0 * (widget.rank! + 1).toString().length),
                        child: Chip(
                          padding: EdgeInsets.only(bottom: 8.0),
                          label: Text(
                            '#${(widget.rank! + 1).toString()}',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: CpTheme.of(context).secondaryTextColor,
                                ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrentPrice(
                          widget.price!,
                          Localizations.localeOf(context).toString(),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 28),
                      ),
                      Row(
                        children: [
                          Chip(
                            padding: EdgeInsets.zero,
                            label: Icon(
                              Icons.notifications_outlined,
                              color: CpTheme.of(context).secondaryTextColor,
                              size: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          Chip(
                            padding: EdgeInsets.only(right: 8.0),
                            label: Row(
                              children: [
                                Icon(
                                  widget.priceChange24h! > 0
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                ),
                                Text(
                                  '${widget.priceChange24h!.abs().toStringAsFixed(2)}%',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) => widget.priceChange24h! > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              BlocProvider<CoinDataBloc>(
                create: (_) {
                  CoinDataBloc bloc =
                      CoinDataBloc(context.read<CoinRepository>());
                  bloc.add(
                    FetchCoinHistoricalPrice(id: widget.id.toLowerCase()),
                  );
                  return bloc;
                },
                child: CoinChartWidget(),
              ),
              Divider(height: 32.0),
              BlocProvider<CoinDataBloc>(
                create: (_) {
                  CoinDataBloc bloc =
                      CoinDataBloc(context.read<CoinRepository>());
                  bloc.add(
                    FetchCoinData(id: widget.id.toLowerCase()),
                  );
                  return bloc;
                },
                child: CoinDataWidget(),
              ),
              BlocProvider<CoinDataBloc>(
                create: (_) {
                  CoinDataBloc bloc =
                      CoinDataBloc(context.read<CoinRepository>());
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
