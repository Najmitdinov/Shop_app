import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';

import '../widgets/product_grid.dart';

class FavoriteProductDetails extends StatelessWidget {
  final bool showFavorites;
  const FavoriteProductDetails(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).favorites;
    return GridView.builder(
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
    );
  }
}
