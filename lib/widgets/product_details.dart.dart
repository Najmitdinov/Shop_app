import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';

import '../widgets/product_grid.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Future _future;
  Future productFuture() {
    return Provider.of<Products>(context, listen: false)
        .getProductsFromFireBase();
  }

  @override
  void initState() {
    _future = productFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (ctx, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (dataSnapShot.error == null) {
            return Consumer<Products>(
              builder: (ctx, products, child) {
                return products.list.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3 / 3,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider<Product>.value(
                            value: products.list[index],
                            child: const ProductGrid(),
                          );
                        },
                        itemCount: products.list.length,
                      )
                    : const Center(
                        child: Text('Mahsulotlar xozircha mavjud emas'),
                      );
              },
            );
          } else {
            return const Center(
              child: Text('Mahsulotlar sahifasi xatolik!'),
            );
          }
        }
      },
    );
  }
}
