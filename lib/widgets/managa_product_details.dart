import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';

import '../screens/add_new_products_screen.dart';

class ManagaProductDetails extends StatelessWidget {
  const ManagaProductDetails({super.key});

  void notifyUser(BuildContext context, Function() handler) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ishonchigiz komilmi?'),
          content: const Text('Mahsulot o\'chirilmoqda!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'BEKOR QILISH',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: handler,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'O\'CHIRISH',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final products = Provider.of<Products>(context);
    final scaffoldMessanger = ScaffoldMessenger.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: product.imgUrl[0].startsWith('assets')
              ? Image.asset(
                  product.imgUrl[0],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 100,
                )
              : Image.network(
                  product.imgUrl[0],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 100,
                ),
        ),
        title: Text(
          product.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          product.discount > 0
              ? '\$${products.totalDiscount(product.id).toStringAsFixed(2)}'
              : '\$${product.price.toStringAsFixed(2)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddNewProductsScreen.routeName,
                  arguments: product.id,
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.amber,
              ),
            ),
            IconButton(
              onPressed: () {
                notifyUser(
                  context,
                  () async {
                    try {
                      Navigator.of(context).pop();
                      await Provider.of<Products>(context, listen: false)
                          .deleteAllProduct(product.id);
                    } catch (error) {
                      scaffoldMessanger.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            error.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
