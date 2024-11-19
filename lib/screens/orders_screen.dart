import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/orders.dart';

import '../widgets/app_drawer.dart';

import '../widgets/order_details.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Buyurtmalar'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          final order = orders.list[index];
          return OrderDetails(
            order.id,
            order.date,
            order,
          );
        },
        itemCount: orders.list.length,
      ),
    );
  }
}
