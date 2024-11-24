import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/carts.dart';
import '../providers/orders.dart';
import '../providers/products.dart';
import '../providers/auth.dart';

import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/my_home_page.dart';
import '../screens/manage_product_screen.dart';
import '../screens/add_new_products_screen.dart';
import "../screens/auth_screen.dart";

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
        ChangeNotifierProvider<Auth>(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, previousProducts) => previousProducts!
            ..setParams(
              auth.toket,
              auth.userId,
            ),
        ),
        ChangeNotifierProvider<Carts>(
          create: (ctx) => Carts(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previousOrder) => previousOrder!
            ..setParams(
              auth.toket,
              auth.userId,
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: auth.isAuth
                ? const MyHomePage()
                : FutureBuilder(
                    future: auth.autoLogIn(),
                    builder: (c, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          ),
                        );
                      } else {
                        return const AuthScreen();
                      }
                    },
                  ),
            routes: {
              MyHomePage.routeName: (ctx) => const MyHomePage(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ManageProductScreen.routeName: (ctx) =>
                  const ManageProductScreen(),
              AddNewProductsScreen.routeName: (ctx) =>
                  const AddNewProductsScreen(),
            },
          );
        },
      ),
    );
  }
}
