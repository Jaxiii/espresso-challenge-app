import 'dart:io';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/coin_data/coin_data_bloc.dart';
import '../../features/coin_data/coin_data_event.dart';
import '../../features/coin_data/coin_data_state.dart';
import '../../features/coin_data/coin_data_view.dart';
import '../../repository/coin_repository.dart';
import '../theme.dart';
import '../utils/utils.dart';
import '../widgets/no_data.dart';
import '../widgets/price_row.dart';
import '../widgets/rank_chip.dart';

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
    Key? key,
    required this.id,
    required this.name,
    required this.symbol,
    this.rank,
    this.price,
    this.marketCap,
    this.priceChange24h,
    this.imageUrl,
  }) : super(key: key);

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
  }) {
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
  }

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Color favoriteColor = Colors.white;
  late IconData favoriteIcon = Icons.star_outline_rounded;
  late String imageUrl = widget.imageUrl ?? '';

  Future<void> shareCoin() async => await Share.share(
      'Hey! Check out ${widget.name} on EspressoCash <InsertLink>! 🚀');

  Future<void> favoriteCoin() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favorite_${widget.id}';
    if (prefs.containsKey(key)) {
      await prefs.remove(key);
      setState(() {
        favoriteColor = Colors.white;
        favoriteIcon = Icons.star_outline_rounded;
      });
    } else {
      await prefs.setBool(key, true);
      setState(() {
        favoriteColor = Colors.amber;
        favoriteIcon = Icons.star_rounded;
      });
    }
    await HapticFeedback.mediumImpact();
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final key = 'favorite_${widget.id}';
      setState(() {
        if (prefs.containsKey(key)) {
          favoriteColor = Colors.amber;
          favoriteIcon = Icons.star_rounded;
        } else {
          favoriteColor = Colors.white;
          favoriteIcon = Icons.star_outline_rounded;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CpTheme.of(context).backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCoinAppBarIconImage(),
            const SizedBox(width: 8.0),
            Text(
              widget.symbol.toUpperCase(),
            ),
          ],
        ),
        actions: _buildActionButtons,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCoinDataSection(),
              _buildCoinChartSection(),
              const Divider(height: 32.0),
              _buildCoinPriceSection(),
              const Divider(height: 32.0),
              _buildCoinDataWidgetSection(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get _buildActionButtons {
    return [
      IconButton(
        icon: Icon(favoriteIcon, size: 26, color: favoriteColor),
        onPressed: favoriteCoin,
      ),
      IconButton(
        onPressed: shareCoin,
        icon: Icon(Platform.isAndroid ? Icons.share : Icons.ios_share_outlined),
      ),
    ];
  }

  Widget _buildCoinDataSection() {
    return BlocProvider<CoinDataBloc>(
      create: (_) {
        final bloc = CoinDataBloc(context.read<CoinRepository>());
        bloc.add(FetchCoinData(id: widget.id));
        return bloc;
      },
      child: BlocBuilder<CoinDataBloc, CoinDataState>(
        builder: (context, state) {
          if (state is CoinDataLoading && state.isInitialLoad) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CoinDataError) {
            if (state.error == EspressoCashError.notFound) {
              return const SizedBox();
            }
            debugPrint('${state.message}${state.error}');
            return const SizedBox();
          }
          if (state is CoinDataLoaded) {
            if (state.coinData.id.isEmpty) {
              return const NoDataText();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.headlineSmall!,
                    ),
                    const SizedBox(width: 8.0),
                    RankChip(rank: widget.rank ?? state.coinData.marketCapRank),
                  ],
                ),
                PriceRow(
                  price: formatCurrentPrice(
                    widget.price ??
                        state.coinData.marketData['current_price']['usd'],
                    Localizations.localeOf(context).toString(),
                  ),
                  priceChange: widget.priceChange24h ??
                      state.coinData.marketData['price_change_percentage_24h']
                          .toDouble(),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildCoinChartSection() {
    return BlocProvider<CoinDataBloc>(
      create: (_) {
        final bloc = CoinDataBloc(context.read<CoinRepository>());
        bloc.add(FetchCoinHistoricalPrice(id: widget.id.toLowerCase()));
        return bloc;
      },
      child: CoinChartBlocWidget(),
    );
  }

  Widget _buildCoinPriceSection() {
    return BlocProvider<CoinDataBloc>(
      create: (_) {
        final bloc = CoinDataBloc(context.read<CoinRepository>());
        bloc.add(FetchCoinPrice(id: widget.id.toLowerCase()));
        return bloc;
      },
      child: CoinPriceBlocWidget(
        id: widget.id,
        symbol: widget.symbol,
      ),
    );
  }

  Widget _buildCoinDataWidgetSection() {
    return BlocProvider<CoinDataBloc>(
      create: (_) {
        final bloc = CoinDataBloc(context.read<CoinRepository>());
        bloc.add(FetchCoinData(id: widget.id.toLowerCase()));
        return bloc;
      },
      child: CoinDataBlocWidget(),
    );
  }

  Widget _buildCoinAppBarIconImage() {
    return BlocProvider<CoinDataBloc>(
      create: (_) {
        final bloc = CoinDataBloc(context.read<CoinRepository>());
        bloc.add(FetchCoinData(id: widget.id));
        return bloc;
      },
      child: CoinImageBlocWidget(),
    );
  }
}
