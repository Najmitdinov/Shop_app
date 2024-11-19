import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Carts with ChangeNotifier {
  final Map<String, CartItem> _list = {};

  Map<String, CartItem> get list {
    return {..._list};
  }

  void addToCart(
    String productId,
    String title,
    String imgUrl,
    double price,
    double totalPrice,
    int quantity,
    Color color,
  ) {
    if (_list.containsKey(productId)) {
      _list.update(
        productId,
        (current) => CartItem(
          id: current.id,
          title: current.title,
          imgUrl: current.imgUrl,
          price: current.price,
          totalPrice: current.totalPrice + current.price,
          quantity: current.quantity + 1,
          bgColor: current.bgColor,
        ),
      );
    } else {
      _list.putIfAbsent(
        productId,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          imgUrl: imgUrl,
          price: price,
          totalPrice: totalPrice,
          quantity: quantity,
          bgColor: color,
        ),
      );
    }

    notifyListeners();
  }

  void reduceNumberProduct(String id, {bool isGridBotton = false}) {
    if (!_list.containsKey(id)) {
      return;
    }
    if (_list[id]!.quantity > 1) {
      _list.update(
        id,
        (current) => CartItem(
          id: current.id,
          title: current.title,
          imgUrl: current.imgUrl,
          price: current.price,
          totalPrice: current.totalPrice - current.price,
          quantity: current.quantity - 1,
          bgColor: current.bgColor,
        ),
      );
    } else if (isGridBotton) {
      _list.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }

  void deleteProduct(String id) {
    _list.remove(id);
    notifyListeners();
  }

  double totalSum() {
    double sum = 0.0;
    _list.forEach((key, product) {
      sum += product.price * product.quantity;
    });
    return sum;
  }

  int cartLength() {
    return _list.length;
  }
}
