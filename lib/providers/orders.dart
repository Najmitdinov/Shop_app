import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  final List<Order> _list = [];

  List<Order> get list {
    return [..._list];
  }

  void addToOrders(List<CartItem> product) {
    _list.insert(
      0,
      Order(
        id: UniqueKey().toString(),
        date: DateTime.now(),
        product: product,
      ),
    );
    notifyListeners();
  }
}
