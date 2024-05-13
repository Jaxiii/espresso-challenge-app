import 'package:equatable/equatable.dart';

abstract class CryptoDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCoinData extends CryptoDataEvent {
  final String id;
  FetchCoinData({required this.id});
}

class FetchCoinHistoricalPrice extends CryptoDataEvent {
  final String id;
  FetchCoinHistoricalPrice({required this.id});
}

class FetchCoinPrice extends CryptoDataEvent {
  final String id;
  FetchCoinPrice({required this.id});
}
