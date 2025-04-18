import 'package:hava_havai/data/models/product_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
   @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final Product product;
  RemoveFromCart(this.product);
}

class IncreaseQuantity extends CartEvent {
  final Product product;
  IncreaseQuantity(this.product);
}

class DecreaseQuantity extends CartEvent {
  final Product product;
  DecreaseQuantity(this.product);
}
