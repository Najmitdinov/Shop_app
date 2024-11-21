import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _list = [];

  List<Order> get list {
    return [..._list];
  }

  Future<void> addToOrders(List<CartItem> product) async {
    final url = Uri.parse(
        'https://fir-app-af62a-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'data': DateTime.now().toIso8601String(),
            'product': product
                .map(
                  (pro) => {
                    'id': pro.id,
                    'title': pro.title,
                    'imgUrl': pro.imgUrl,
                    'price': pro.price,
                    'totalPrice': pro.totalPrice,
                    'quantity': pro.quantity,
                    'bgColor': pro.bgColor.value,
                  },
                )
                .toList(),
          },
        ),
      );
      _list.insert(
        0,
        Order(
          id: jsonDecode(response.body)['name'],
          date: DateTime.now(),
          product: product,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getOrdersFromFirebase() async {
    final url = Uri.parse(
        'https://fir-app-af62a-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) == null) {
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      List<Order> uploadedOrders = [];
      data.forEach(
        (productId, order) {
          uploadedOrders.insert(
            0,
            Order(
              id: productId,
              date: DateTime.parse(order['data']),
              product: (order['product'] as List<dynamic>)
                  .map(
                    (pro) => CartItem(
                      id: pro['id'],
                      title: pro['title'],
                      imgUrl: pro['imgUrl'],
                      price: pro['price'],
                      totalPrice: pro['totalPrice'],
                      quantity: pro['quantity'],
                      bgColor: Color(pro['bgColor']),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _list = uploadedOrders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
