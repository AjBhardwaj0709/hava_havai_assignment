import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final int limit;
  final int skip;

  FetchProducts({required this.limit, required this.skip});

  @override
  List<Object?> get props => [limit, skip];
}
