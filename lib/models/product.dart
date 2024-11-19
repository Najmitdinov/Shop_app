import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final List<String> imgUrl;
  final String ingredients;
  String quality;
  final int discount;
  final double price;
  Color color;
  int quantity;
  bool isLike;

  Product({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.ingredients,
    required this.quality,
    required this.discount,
    required this.price,
    required this.color,
    this.quantity = 1,
    this.isLike = false,
  });

  void toggleLike() {
    isLike = !isLike;
    notifyListeners();
  }
}
