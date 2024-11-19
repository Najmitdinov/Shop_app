import 'package:flutter/material.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  final List<Product> _list = [
    Product(
      id: UniqueKey().toString(),
      title: 'Sneakers',
      imgUrl: ['assets/images/sneakers.png'],
      ingredients: 'Red, Magnificent, Fabric',
      quality: 'New',
      discount: 0,
      price: 9.99,
      color: Colors.red,
      // quantity: 1,
    ),
    Product(
      id: UniqueKey().toString(),
      title: 'Hat',
      imgUrl: [
        'assets/images/hat.png',
        'assets/images/hats1.png',
        'assets/images/hats2.png',
      ],
      ingredients: 'Brown, Magnificent, Fabric',
      quality: '',
      discount: 20,
      price: 78.99,
      color: Colors.brown,
      // quantity: 1,
    ),
    Product(
      id: UniqueKey().toString(),
      title: 'Gloves',
      imgUrl: [
        'assets/images/gloves.png',
        'assets/images/glov.png',
      ],
      ingredients: 'Blue, Magnificent, Fabric',
      quality: 'New',
      discount: 10,
      price: 99.99,
      color: Colors.blue,
      // quantity: 1,
    ),
    Product(
      id: UniqueKey().toString(),
      title: 'Game Controller',
      imgUrl: [
        'assets/images/controller.png',
      ],
      ingredients: 'Perfect Controller for game',
      quality: 'New',
      discount: 20,
      price: 120.99,
      color: const Color.fromRGBO(66, 56, 71, 1),
      // quantity: 1,
    ),
  ];

  void increaseNumberProduct(String id) {
    for (var product in _list) {
      if (product.id == id) {
        product.quantity++;
        product.price * (product.quantity - 1);
      }
    }

    notifyListeners();
  }

  void reduceNumberProduct(String id) {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].id == id && _list[i].quantity <= 1) {
        return;
      }
      if (_list[i].id == id) {
        _list[i].quantity--;
        _list[i].price % _list[i].quantity;
      }
    }
    notifyListeners();
  }

  double calculateDicount(String id) {
    double calculateDicount = 0.0;
    for (var product in _list) {
      if (product.id == id && product.discount > 0) {
        final totalDiscounPercent = product.price * (product.discount / 100);
        calculateDicount += product.price - totalDiscounPercent;
      }
    }
    return calculateDicount;
  }

  double totalDiscount(String id) {
    double totalDiscount = 0.0;
    for (var product in _list) {
      if (product.id == id && product.discount > 0) {
        final totalDiscounPercent = product.price * (product.discount / 100);
        final totalDiscountSum = product.price - totalDiscounPercent;

        totalDiscount += totalDiscountSum * product.quantity;
      }
    }
    return totalDiscount;
  }

  double totalSum(String id) {
    double totalSum = 0.0;

    for (var product in _list) {
      if (product.id == id && product.discount <= 0 && totalSum == 0.0) {
        totalSum = product.price;
      }
      if (product.id == id) totalSum += product.price * (product.quantity - 1);
    }
    return totalSum;
  }

  void resetThePrice() {
    for (var product in _list) {
      product.quantity = 1;
    }
    notifyListeners();
  }

  void addNewProduct(Product product) {
    final newProduct = Product(
      id: UniqueKey().toString(),
      title: product.title,
      imgUrl: product.imgUrl,
      ingredients: product.ingredients,
      quality: product.quality,
      discount: product.discount,
      price: product.price,
      color: product.color,
    );
    _list.add(newProduct);
    notifyListeners();
  }

  void updateProduct(Product updateProduct) {
    final productIndex =
        _list.indexWhere((product) => product.id == updateProduct.id);
    if (productIndex >= 0) {
      _list[productIndex] = updateProduct;
    }
    notifyListeners();
  }

  Product findById(String id) {
    return _list.firstWhere((product) => product.id == id);
  }

  void deleteAllProduct(String productId) {
    _list.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  List<Product> get favorites {
    return _list.where((product) => product.isLike).toList();
  }

  List<Product> get list {
    return [..._list];
  }
}
