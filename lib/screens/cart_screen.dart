import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/cart_item.dart';

import '../providers/carts.dart';
import '../providers/orders.dart';
import '../providers/products.dart';

import '../screens/orders_screen.dart';

import '../widgets/cart_details.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<Carts>(context);
    final orders = Provider.of<Orders>(context);
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savatcha'),
        actions: [
          TextButton(
            onPressed: () {
              carts.clearCart();
              products.resetThePrice();
            },
            child: const Text(
              'Tozalash',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Sizning savatchadagi mahsulotlaringiz!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemBuilder: (ctx, index) {
                final cart = carts.list.values.toList()[index];
                return ChangeNotifierProvider<CartItem>.value(
                  value: cart,
                  child: CartDetails(
                    productId: carts.list.keys.toList()[index],
                    // title: cart.title,
                    // imgUrl: cart.imgUrl,
                    // bgColor: cart.bgColor,
                    // price: cart.price,
                  ),
                );
              },
              itemCount: carts.list.length,
            ),
          ),
        ],
      ),
      bottomSheet: BottomAppBar(
        height: 120,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Umumiy summasi:'),
                Text(
                  '\$${carts.totalSum().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
            carts.list.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {
                      if (carts.list.isEmpty) {
                        return;
                      }
                      orders.addToOrders(
                        carts.list.values.toList(),
                      );
                      carts.clearCart();
                      products.resetThePrice();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Xarid qilish \$${carts.totalSum().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        OrdersScreen.routeName,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Buyurtmalar sahifasiga o\'tish',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
