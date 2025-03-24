import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hava_havai/data/models/product_model.dart';
import 'package:hava_havai/logic/blocs/like_bloc.dart';
import 'package:hava_havai/logic/events/like_event.dart';
import 'package:hava_havai/logic/states/like_state.dart';
import 'package:hava_havai/presentation/screens/product_detail_screen.dart';
import 'package:share_plus/share_plus.dart';

class LikedItemsPage extends StatelessWidget {
  const LikedItemsPage({Key? key, required List<Product> likedProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 227, 235),
        title: const Center(child: Text("Liked Items")),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(7),
          child: Divider(color: Colors.black, thickness: 1),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 251, 227, 235),
        child: BlocBuilder<LikeBloc, LikeState>(
          builder: (context, state) {
            if (state.likedProducts.isEmpty) {
              return const Center(
                child: Text("No liked items yet!"),
              );
            }

            return ListView.builder(
              itemCount: state.likedProducts.length,
              itemBuilder: (context, index) {
                Product product = state.likedProducts[index];
                final discountedPrice =
                    product.price * (1 - product.discountPercentage / 100);

                return Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                    // ✅ Wrap everything inside GestureDetector to navigate to detail screen
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },

                    leading: Image.network(
                      product.thumbnail,
                      width: 50,
                    ),

                    title: Text(product.tittle),

                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "₹${product.price.toStringAsFixed(2)} ",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: " ₹${discountedPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Delete Icon Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context
                                .read<LikeBloc>()
                                .add(ToogleLikeEvent(product));
                          },
                        ),

                        // Share Icon Button
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.blueGrey),
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
