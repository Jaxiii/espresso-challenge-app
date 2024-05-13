import 'package:api/api.dart';
import 'package:equatable/equatable.dart';

abstract class CoinDataState extends Equatable {
  @override
  List<Object> get props => [];
}

class CoinDataInitial extends CoinDataState {}

class CoinDataLoading extends CoinDataState {
  final bool isInitialLoad;

  CoinDataLoading({this.isInitialLoad = true});

  @override
  List<Object> get props => [isInitialLoad];
}

class CoinDataLoaded extends CoinDataState {
  final CoinDataMapDto coinData;
  CoinDataLoaded(this.coinData);
}

class CoinDataError extends CoinDataState {
  final String message;
  final EspressoCashError? error;

  CoinDataError(this.message, this.error);

  @override
  List<Object> get props => [message];
}
