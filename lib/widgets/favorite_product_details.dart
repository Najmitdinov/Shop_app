import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';

import '../widgets/product_grid.dart';

class FavoriteProductDetails extends StatelessWidget {
  const FavoriteProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).favorites;
    return productData.isNotEmpty
        ? GridView.builder(
            padding: const EdgeInsets.all(5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 3,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (ctx, index) {
              return ChangeNotifierProvider<Product>.value(
                value: productData[index],
                child: const ProductGrid(),
              );
            },
            itemCount: productData.length,
          )
        : const Center(
            child: Text('Sevimli mahsulotlar mavjud emas!'),
          );
  }
}
