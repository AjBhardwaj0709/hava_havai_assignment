import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hava_havai/logic/blocs/cart_bloc.dart';
import 'package:hava_havai/logic/blocs/product_bloc.dart';
import 'package:hava_havai/logic/events/cart_event.dart';
import 'package:hava_havai/logic/events/product_event.dart';
import 'package:hava_havai/logic/states/cart_state.dart';
import 'package:hava_havai/logic/states/product_state.dart';
import 'package:hava_havai/presentation/screens/cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();
  final int _limit = 10;
  int _skip = 0;
  bool _isFetching = false;
  Map<int, bool> isCheckedMap = {};
  @override
  void initState() {
    super.initState();
    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _fetchMoreProducts();
      }
    });
  }

  void _fetchProducts() {
    context.read<ProductBloc>().add(FetchProducts(limit: _limit, skip: _skip));
  }

  void _fetchMoreProducts() {
    final productBloc = context.read<ProductBloc>();
    if (!_isFetching &&
        productBloc.state is ProductLoaded &&
        (productBloc.state as ProductLoaded).hasMore) {
      setState(() {
        _isFetching = true;
      });

      _skip = (productBloc.state as ProductLoaded).products.length;
      context
          .read<ProductBloc>()
          .add(FetchProducts(limit: _limit, skip: _skip));

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _isFetching = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 227, 235),
        title: Center(child: Text("Catalogue")),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, size: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state.cartItems.isNotEmpty) {
                      return CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 10,
                        child: Text(
                          state.cartItems.length.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          )
        ],
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
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading && _skip == 0) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        
                        physics: AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: state.products.length, // Extra for loading
                        itemBuilder: (context, index) {
                          if (index == state.products.length) {
                            return _isFetching
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox.shrink();
                          }

                          final product = state.products[index];
                          final discountedPrice = product.price *
                              (1 - product.discountPercentage / 100);

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: Image.network(
                                        product.thumbnail,
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                   Positioned(
                                      right: 10,
                                      top: 110,
                                      child: BlocBuilder<CartBloc, CartState>(
                                        builder: (context, cartState) {
                                          bool isChecked = cartState
                                                  .isCheckedMap[product.id] ??
                                              false;

                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 4),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 5),
                                                backgroundColor: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (!isChecked) {
                                                  context
                                                      .read<CartBloc>()
                                                      .add(AddToCart(product));
                                                } else {
                                                  context.read<CartBloc>().add(
                                                      RemoveFromCart(product));
                                                }
                                              },
                                              child: Text(
                                                isChecked ? "Added" : "Add",
                                                style: TextStyle(
                                                  color: isChecked
                                                      ? Colors.green
                                                      : Colors.pink,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.tittle,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        product.brand,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "₹${product.price.toStringAsFixed(2)} ",
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  " ₹${discountedPrice.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${product.discountPercentage.toStringAsFixed(2)}% OFF",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProductError) {
              return Center(
                child: Text(state.message),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
