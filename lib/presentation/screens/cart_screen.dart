import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hava_havai/logic/blocs/cart_bloc.dart';
import 'package:hava_havai/logic/events/cart_event.dart';
import 'package:hava_havai/logic/states/cart_state.dart';

class CartScreen extends StatelessWidget {
  int totalItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 227, 235),
        title: Center(child: Text("Cart")),
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 251, 227, 235),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.cartItems.isEmpty) {
                return Center(
                  child: Text("Your cart is empty"),
                );
              }
        
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = state.cartItems.keys.elementAt(index);
                        final quantity = state.cartItems[product]!;
                        final discountedPrice = product.price *
                            (1 - product.discountPercentage / 100);
        
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.thumbnail,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
        
                                // Product Details & Quantity Control
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            product.tittle,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          BlocBuilder<CartBloc, CartState>(
                                            builder: (context, state) {
                                              return Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(RemoveFromCart(
                                                              product));
                                                    },
                                                    icon: Icon(Icons.delete),
                                                  ));
                                            },
                                          )
                                        ],
                                      ),
                                      Text(
                                        product.brand,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            "₹${product.price.toStringAsFixed(2)} ",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "₹${discountedPrice.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${product.discountPercentage.toStringAsFixed(2)}% OFF",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove,
                                                  color: quantity > 1
                                                      ? Colors.black
                                                      : Colors.grey),
                                              onPressed: quantity > 1
                                                  ? () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(DecreaseQuantity(
                                                              product));
                                                    }
                                                  : null,
                                            ),
                                            Text(
                                              quantity.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.pinkAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add,
                                                  color: Colors.black),
                                              onPressed: () {
                                                context.read<CartBloc>().add(
                                                    IncreaseQuantity(product));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Amount Price",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "  ₹${state.totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text(
                                    "Check Out",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  if (state.totalQuantity > 0) ...[
                                    SizedBox(
                                      width: 5,
                                    ),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        state.totalQuantity.toString(),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.pink),
                                      ),
                                    )
                                  ]
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink, // Button color
                                foregroundColor: Colors.white, // Text color
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
