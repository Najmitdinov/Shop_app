import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderDetails extends StatefulWidget {
  final String id;
  final DateTime date;
  final Order order;
  const OrderDetails(this.id, this.date, this.order, {super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Buyurtma kodi: [${widget.date.microsecond}]',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            subtitle: Text(
              DateFormat('dd.MM.yyyy').format(widget.date),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
          if (isExpanded)
            SizedBox(
              height: min(widget.order.product.length * 50 + 20, 100),
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  final productOrder = widget.order.product[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      child: productOrder.imgUrl.startsWith('assets')
                          ? Image.asset(
                              productOrder.imgUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 100,
                            )
                          : Image.network(
                              productOrder.imgUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 100,
                            ),
                    ),
                    title: Text(
                      productOrder.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      '\$${productOrder.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      'x${productOrder.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
                itemCount: widget.order.product.length,
              ),
            )
        ],
      ),
    );
  }
}
