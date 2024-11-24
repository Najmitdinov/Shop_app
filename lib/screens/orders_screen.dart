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
  late Future _future;
  Future orderFuture() {
    return Provider.of<Orders>(context, listen: false).getOrdersFromFirebase();
  }

  @override
  void initState() {
    _future = orderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Buyurtmalar'),
      ),
      body: RefreshIndicator(
        onRefresh: () => orderFuture(),
        child: FutureBuilder(
          future: _future,
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            } else {
              if (dataSnapShot.error == null) {
                return Consumer<Orders>(
                  builder: (ctx, orders, child) {
                    return orders.list.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (ctx, index) {
                              final order = orders.list[index];
                              return OrderDetails(
                                order.id,
                                order.date,
                                order,
                              );
                            },
                            itemCount: orders.list.length,
                          )
                        : const Center(
                            child: Text('Buyurtmalar mavjud emas!'),
                          );
                  },
                );
              } else {
                return const Center(
                  child: Text('Buyurtmalarda xatolik yuz berdi!'),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
