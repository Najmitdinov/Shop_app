import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import '../providers/carts.dart';
import '../providers/products.dart';

import '../models/cart_item.dart';

class CartDetails extends StatelessWidget {
  final String productId;

  const CartDetails({
    super.key,
    required this.productId,
  });

  void showNotifyScreen(BuildContext context, Function() handler) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ishonchingiz komilmi?'),
          content: const Text('Mahsulot o\'chirilmoqda!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'BEKOR QILISH',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: handler,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'O\'CHIRISH',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<Carts>(context);
    final cart = Provider.of<CartItem>(context);
    final products = Provider.of<Products>(context);
    final product = products.findById(productId);

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          ElevatedButton(
            onPressed: () {
              showNotifyScreen(
                context,
                () {
                  carts.deleteProduct(productId);
                  products.resetThePrice();
                  Navigator.of(context).pop();
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(5),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  product.color.withOpacity(0.6),
                  product.color.withOpacity(0.6),
                  product.color.withOpacity(0.4),
                  product.color.withOpacity(0.6),
                ],
              ),
            ),
            child: product.imgUrl[0].startsWith('assets')
                ? Image.asset(
                    product.imgUrl[0],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  )
                : Image.network(
                    product.imgUrl[0],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
          ),
          title: Text(
            cart.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            cart.totalPrice.toStringAsFixed(2),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  carts.reduceNumberProduct(productId);
                },
                icon: const Icon(Icons.remove),
              ),
              Container(
                alignment: Alignment.center,
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Text(
                  cart.quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  carts.addToCart(
                    productId,
                    cart.title,
                    cart.imgUrl,
                    cart.price,
                    product.discount <= 0
                        ? products.totalSum(product.id)
                        : products.totalDiscount(product.id),
                    cart.quantity,
                    cart.bgColor,
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
