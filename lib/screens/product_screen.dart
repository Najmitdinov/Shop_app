import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/carts.dart';
import '../providers/products.dart';

import '../screens/cart_screen.dart';

import '../widgets/product_item_details.dart';
import '../widgets/product_item_header.dart';

class ProductScreen extends StatelessWidget {
  final String productData;
  const ProductScreen(this.productData, {super.key});

  static const routeName = '/product-screen';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final product =
        products.list.firstWhere((product) => product.id == productData);

    final deviceHieght = MediaQuery.of(context).size.height;
    final carts = Provider.of<Carts>(context);
    return Scaffold(
      body: Stack(
        children: [
          ProductItemHeader(
            deviceHieght: deviceHieght,
            product: product,
          ),
          ProductItemDetails(
            deviceHieght: deviceHieght,
            product: product,
          ),
        ],
      ),
      bottomSheet: BottomAppBar(
        shadowColor: Colors.black,
        elevation: 10,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Umumiy Narxi:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.discount <= 0
                      ? products.totalSum(product.id).toStringAsFixed(2)
                      : products.totalDiscount(product.id).toStringAsFixed(2),
                  style: TextStyle(
                    color: product.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            carts.list.containsKey(product.id)
                ? ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        CartScreen.routeName,
                        arguments: productData,
                      );
                      products.resetThePrice();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Savatchaga borish',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      carts.addToCart(
                        productData,
                        product.title,
                        product.imgUrl[0],
                        product.discount <= 0
                            ? products.totalSum(product.id)
                            : products.calculateDicount(productData),
                        product.discount <= 0
                            ? products.totalSum(product.id)
                            : products.totalDiscount(productData),
                        product.quantity,
                        product.color,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Savatchaga qo\'shish',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
