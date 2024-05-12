import 'package:api/api.dart';
import 'package:equatable/equatable.dart';

abstract class CryptoState extends Equatable {
  @override
  List<Object> get props => [];
}

class CryptoInitial extends CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<CoinDataMapDto> cryptoData;
  CryptoLoaded(this.cryptoData);
  @override
  List<Object> get props => [cryptoData];
}

class CryptoError extends CryptoState {
  final String message;
  CryptoError(this.message);
  @override
  List<Object> get props => [message];
}
