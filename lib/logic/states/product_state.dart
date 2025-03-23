import 'package:equatable/equatable.dart';
import 'package:hava_havai/data/models/product_model.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;

  ProductLoaded({required this.products, required this.hasMore});
  @override
  List<Object?> get props => [products, hasMore];
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message, );
}
