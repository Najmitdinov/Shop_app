import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/carts.dart';
import '../providers/products.dart';

import '../screens/product_screen.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
  });

  Widget box(Color bgColor, String title, Color color) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 3,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: color,
          ),
        ),
      ),
    );
  }

  Widget title(String title, Color color, double size) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  void openProductDetaislScreen(BuildContext context, String product) {
    showModalBottomSheet(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      builder: (ctx) {
        return ProductScreen(product);
      },
    );
  }

  void openNotifyScreen(BuildContext context, Function() handler) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 2),
        actionOverflowThreshold: 1,
        content: const Text(
          'Mahsulot savatchaga qo\'shildi!',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'BEKOR QILISH',
          textColor: Colors.black,
          onPressed: handler,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final products = Provider.of<Products>(context);
    final carts = Provider.of<Carts>(context);
    return GridTile(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          product.discount > 0
              ? box(
                  product.color,
                  '${product.discount}% chegirma',
                  Colors.white,
                )
              : Container(),
          product.quality.isNotEmpty
              ? box(
                  Colors.white,
                  product.quality,
                  product.color,
                )
              : Container(),
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(product.title, product.color, 23),
                title(product.ingredients, product.color, 17),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: product.discount > 0
                                ? Colors.white38
                                : Colors.white,
                          ),
                        ),
                        if (product.discount > 0)
                          Container(
                            width: 70,
                            height: 2,
                            color: Colors.red,
                          ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      product.discount > 0
                          ? '\$${products.calculateDicount(product.id).toStringAsFixed(2)}'
                          : '',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
              child: IconButton(
                onPressed: () {
                  openNotifyScreen(
                    context,
                    () {
                      carts.reduceNumberProduct(product.id, isGridBotton: true);
                      products.reduceNumberProduct(product.id);
                    },
                  );
                  carts.addToCart(
                    product.id,
                    product.title,
                    product.imgUrl[0],
                    product.discount <= 0
                        ? product.price
                        : products.calculateDicount(product.id),
                    product.discount <= 0
                        ? products.totalSum(product.id)
                        : products.totalDiscount(product.id),
                    product.quantity,
                    product.color,
                  );
                  products.increaseNumberProduct(product.id);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          openProductDetaislScreen(context, product.id);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                product.color.withOpacity(0.5),
                product.color.withOpacity(0.5),
                product.color.withOpacity(0.3),
                product.color.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              product.imgUrl[0].startsWith('assets')
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Image.asset(
                        product.imgUrl[0],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 200,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          bottom: 50.0, left: 50, right: 50),
                      child: Image.network(
                        product.imgUrl[0],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
