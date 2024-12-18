import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

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

  Future<void> toggleLike(String token, String userId) async {
    var oldIsLike = isLike;
    isLike = !isLike;
    notifyListeners();
    final url = Uri.parse(
        'https://fir-app-af62a-default-rtdb.firebaseio.com/isFavorite/$userId/$id.json?auth=$token');

    try {
      final response = await http.put(
        url,
        body: jsonEncode(isLike),
      );
      if (response.statusCode >= 400) {
        isLike = oldIsLike;
        notifyListeners();
      }
    } catch (error) {
      isLike = oldIsLike;
      notifyListeners();
    }
  }
}
