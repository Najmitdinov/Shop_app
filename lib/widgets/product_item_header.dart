import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/carts.dart';
import '../providers/products.dart';

class ProductItemHeader extends StatelessWidget {
  const ProductItemHeader({
    super.key,
    required this.product,
    required this.deviceHieght,
  });

  final Product product;
  final double deviceHieght;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final carts = Provider.of<Carts>(context);
    return Container(
      decoration: BoxDecoration(
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
      height: deviceHieght,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: AlignmentDirectional.center,
                margin: const EdgeInsets.only(right: 10, top: 30),
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ],
          ),
          product.imgUrl[0].startsWith('assets')
              ? Image.asset(
                  product.imgUrl[0],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 200,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Image.network(
                    product.imgUrl[0],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  products.reduceNumberProduct(product.id);
                },
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  carts.list.containsKey(product.id)
                      ? '${product.quantity}'
                      : '${product.quantity}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  products.increaseNumberProduct(product.id);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
