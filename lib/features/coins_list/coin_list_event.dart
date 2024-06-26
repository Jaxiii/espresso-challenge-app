import 'package:equatable/equatable.dart';

abstract class CryptoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCoinListWithMarket extends CryptoEvent {}

class FetchCoinList extends CryptoEvent {}

class LoadMoreCoins extends CryptoEvent {}
