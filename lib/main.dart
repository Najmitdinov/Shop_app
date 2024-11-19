import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/carts.dart';
import '../providers/orders.dart';
import '../providers/products.dart';

import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/my_home_page.dart';
import '../screens/manage_product_screen.dart';
import '../screens/add_new_products_screen.dart';

import '../styles/my_shop_styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData theme = MyShopStyles.theme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider<Carts>(
          create: (ctx) => Carts(),
        ),
        ChangeNotifierProvider<Orders>(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: MyHomePage.routeName,
        routes: {
          MyHomePage.routeName: (ctx) => const MyHomePage(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          ManageProductScreen.routeName: (ctx) => const ManageProductScreen(),
          AddNewProductsScreen.routeName: (ctx) => const AddNewProductsScreen(),
        },
      ),
    );
  }
}
