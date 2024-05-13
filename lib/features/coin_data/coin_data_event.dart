import 'package:equatable/equatable.dart';

abstract class CryptoDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCoinData extends CryptoDataEvent {
  final String id;
  FetchCoinData({required this.id});
}
