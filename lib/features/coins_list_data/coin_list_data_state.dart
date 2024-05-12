import 'package:api/api.dart';
import 'package:equatable/equatable.dart';

abstract class CryptoState extends Equatable {
  @override
  List<Object> get props => [];
}

class CryptoInitial extends CryptoState {}

class CryptoLoading extends CryptoState {
  final bool isInitialLoad;

  CryptoLoading({this.isInitialLoad = true});

  @override
  List<Object> get props => [isInitialLoad];
}

class CryptoLoaded extends CryptoState {
  final List<CoinDataMapDto> cryptoData;
  final bool hasReachedMax;

  CryptoLoaded({required this.cryptoData, this.hasReachedMax = false});

  @override
  List<Object> get props => [cryptoData, hasReachedMax];
}

class CoinListLoaded extends CryptoState {
  final List<CoinMapDto> coinList;
  CoinListLoaded(this.coinList);
}

class CryptoError extends CryptoState {
  final String message;

  CryptoError(this.message);

  @override
  List<Object> get props => [message];
}
