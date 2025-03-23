import 'package:equatable/equatable.dart';
import 'package:hava_havai/data/models/product_model.dart';

class CartState extends Equatable {
  final Map<Product, int> cartItems;
  final double totalPrice;
  CartState({required this.cartItems, required this.totalPrice});
  int get totalQuantity =>
      cartItems.values.fold(0, (sum, quantity) => sum +quantity);
  @override
  List<Object?> get props => [cartItems, totalPrice];
}

class CartInitial extends CartState {
  CartInitial() : super(cartItems: {}, totalPrice: 0);
}
