import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';

import '../screens/add_new_products_screen.dart';

class ManagaProductDetails extends StatelessWidget {
  const ManagaProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final products = Provider.of<Products>(context);
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
                products.deleteAllProduct(product.id);
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
