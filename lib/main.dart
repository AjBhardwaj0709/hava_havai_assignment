import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hava_havai/data/repositories/product_repository.dart';
import 'package:hava_havai/logic/blocs/cart_bloc.dart';
import 'package:hava_havai/logic/blocs/like_bloc.dart';
import 'package:hava_havai/logic/blocs/product_bloc.dart';
import 'package:hava_havai/logic/events/product_event.dart';
import 'package:hava_havai/presentation/screens/catalog_screen.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProductBloc(productRepository: ProductRepository())
                  ..add(FetchProducts(limit: 3000, skip: 0)),
          ),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(
            create: (context) => LikeBloc(),),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: CatalogScreen(),
        ));
  }
}
