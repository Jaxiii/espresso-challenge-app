import 'package:api/api.dart';
import 'package:equatable/equatable.dart';

abstract class CoinListState extends Equatable {
  @override
  List<Object> get props => [];
}

class CoinListInitial extends CoinListState {}

class CoinListLoading extends CoinListState {
  final bool isInitialLoad;

  CoinListLoading({this.isInitialLoad = true});

  @override
  List<Object> get props => [isInitialLoad];
}

class CoinListWithMarketLoaded extends CoinListState {
  final List<CoinMarketMapDto> cryptoData;
  final bool hasReachedMax;

  CoinListWithMarketLoaded(
      {required this.cryptoData, this.hasReachedMax = false});

  @override
  List<Object> get props => [cryptoData, hasReachedMax];
}

class CoinListLoaded extends CoinListState {
  final List<CoinMapDto> coinList;
  CoinListLoaded(this.coinList);
}

class CoinListError extends CoinListState {
  final String message;

  CoinListError(this.message);

  @override
  List<Object> get props => [message];
}
