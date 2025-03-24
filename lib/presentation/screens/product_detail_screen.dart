import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hava_havai/data/models/product_model.dart';
import 'package:hava_havai/logic/blocs/like_bloc.dart';
import 'package:hava_havai/logic/events/like_event.dart';
import 'package:hava_havai/logic/states/like_state.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        product.price * (1 - product.discountPercentage / 100);
    // bool isLiked = state.likedProducts.contains(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.tittle),
        backgroundColor: Color.fromARGB(255, 251, 227, 235),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(7),
          child: Container(
            height: 1,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 251, 227, 235),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.white,
                  child: Image.network(
                    product.thumbnail,
                    height: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.tittle,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              BlocBuilder<LikeBloc, LikeState>(
                                builder: (context, state) {
                                  bool isLiked =
                                      state.likedProducts.contains(product);
                                  return IconButton(
                                      onPressed: () {
                                        context
                                            .read<LikeBloc>()
                                            .add(ToogleLikeEvent(product));
                                      },
                                      icon: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked ? Colors.red : Colors.grey,
                                      ));
                                },
                              ),
                               IconButton(
                                onPressed: () {
                                  Share.share(
                                    "Check out this product: ${product.tittle}\n"
                                    "Brand: ${product.brand}\n"
                                    "Category: ${product.category}\n"
                                    "Price: ₹${product.price.toStringAsFixed(2)}\n"
                                    "Discounted Price: ₹${discountedPrice.toStringAsFixed(2)}\n"
                                    "Description: ${product.description}\n"
                                    "Image: ${product.thumbnail}",
                                  );
                                },
                                icon: Icon(Icons.share, color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Brand: ${product.brand}",
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Category: ${product.category}",
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "₹${product.price.toStringAsFixed(2)} ",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: " ₹${discountedPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "In Stock: ${product.stock}",
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Description:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
