import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/carts.dart';

import '../screens/cart_screen.dart';

class CostumeCart extends StatelessWidget {
  const CostumeCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<Carts>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              CartScreen.routeName,
            );
          },
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            alignment: Alignment.center,
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Text(
              carts.cartLength().toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
