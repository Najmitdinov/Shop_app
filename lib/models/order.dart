import 'package:flutter/material.dart';
import 'package:new_shop_app/models/cart_item.dart';

class Order with ChangeNotifier{
  final String id;
  final DateTime date;
  final List<CartItem> product;

  Order({
    required this.id,
    required this.date,
    required this.product,
  });
}
