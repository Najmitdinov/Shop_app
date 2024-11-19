import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/add_new_products_screen.dart';

import '../widgets/app_drawer.dart';

import '../widgets/managa_product_details.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  static const routeName = '/manage-product-screen';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Mahsulotlar'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewProductsScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemBuilder: (ctx, index) {
          final product = products.list[index];
          return ChangeNotifierProvider.value(
            value: product,
            child: const ManagaProductDetails(),
          );
        },
        itemCount: products.list.length,
      ),
    );
  }
}
