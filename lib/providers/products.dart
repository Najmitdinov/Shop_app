import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../services/http_exception.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: UniqueKey().toString(),
    //   title: 'Sneakers',
    //   imgUrl: ['assets/images/sneakers.png'],
    //   ingredients: 'Red, Magnificent, Fabric',
    //   quality: 'New',
    //   discount: 0,
    //   price: 9.99,
    //   color: Colors.red,
    //   // quantity: 1,
    // ),
    // Product(
    //   id: UniqueKey().toString(),
    //   title: 'Hat',
    //   imgUrl: [
    //     'assets/images/hat.png',
    //     'assets/images/hats1.png',
    //     'assets/images/hats2.png',
    //   ],
    //   ingredients: 'Brown, Magnificent, Fabric',
    //   quality: '',
    //   discount: 20,
    //   price: 78.99,
    //   color: Colors.brown,
    //   // quantity: 1,
    // ),
    // Product(
    //   id: UniqueKey().toString(),
    //   title: 'Gloves',
    //   imgUrl: [
    //     'assets/images/gloves.png',
    //     'assets/images/glov.png',
    //   ],
    //   ingredients: 'Blue, Magnificent, Fabric',
    //   quality: 'New',
    //   discount: 10,
    //   price: 99.99,
    //   color: Colors.blue,
    //   // quantity: 1,
    // ),
    // Product(
    //   id: UniqueKey().toString(),
    //   title: 'Game Controller',
    //   imgUrl: [
    //     'assets/images/controller.png',
    //   ],
    //   ingredients: 'Perfect Controller for game',
    //   quality: 'New',
    //   discount: 20,
    //   price: 120.99,
    //   color: const Color.fromRGBO(66, 56, 71, 1),
    //   // quantity: 1,
    // ),
  ];

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

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

  Future<void> addNewProduct(Product product) async {
    final url = Uri.parse(
        'https://fir-app-af62a-default-rtdb.firebaseio.com/products.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'creatorId': _userId,
            'title': product.title,
            'imgUrl': product.imgUrl,
            'price': product.price,
            'discount': product.discount,
            'ingredients': product.ingredients,
            'quality': product.quality,
            'color': product.color.value,
            'quantity': product.quantity,
          },
        ),
      );
      final productId = (jsonDecode(response.body))['name'];
      final newProduct = Product(
        id: productId,
        title: product.title,
        imgUrl: product.imgUrl,
        ingredients: product.ingredients,
        quality: product.quality,
        discount: product.discount,
        price: product.price,
        color: product.color,
        quantity: product.quantity,
      );
      _list.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getProductsFromFireBase([bool filterUser = false]) async {
    final userString =
        filterUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        'https://fir-app-af62a-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$userString');

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) != null) {
        final favoriteUrl = Uri.parse(
            'https://fir-app-af62a-default-rtdb.firebaseio.com/isFavorite/$_userId.json?auth=$_authToken');
        final favoriteResponse = await http.get(favoriteUrl);
        final favoriteData = jsonDecode(favoriteResponse.body);

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> uploadedProduct = [];
        data.forEach((productId, productData) {
          List<String> images = (productData['imgUrl'] as List<dynamic>)
              .map((item) => item as String)
              .toList();
          uploadedProduct.add(
            Product(
              id: productId,
              title: productData['title'],
              imgUrl: images,
              ingredients: productData['ingredients'],
              quality: productData['quality'],
              discount: productData['discount'],
              price: productData['price'],
              color: Color(productData['color']),
              quantity: productData['quantity'],
              isLike: favoriteData == null
                  ? false
                  : favoriteData[productId] ?? false,
            ),
          );
        });
        _list = uploadedProduct;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product updateProduct) async {
    final productIndex =
        _list.indexWhere((product) => product.id == updateProduct.id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://fir-app-af62a-default-rtdb.firebaseio.com/products/${updateProduct.id}.json?auth=$_authToken');
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'title': updateProduct.title,
              'imgUrl': updateProduct.imgUrl,
              'price': updateProduct.price,
              'ingredients': updateProduct.ingredients,
              'discount': updateProduct.discount,
              'color': updateProduct.color.value,
              'quality': updateProduct.quality,
            },
          ),
        );
        _list[productIndex] = updateProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Product findById(String id) {
    return _list.firstWhere((product) => product.id == id);
  }

  Future<void> deleteAllProduct(String productId) async {
    final url = Uri.parse(
        'https://fir-app-af62a-default-rtdb.firebaseio.com/products/$productId.json?auth=$_authToken');
    try {
      final productIndex =
          _list.indexWhere((product) => product.id == productId);
      final deletingProduct =
          _list.firstWhere((product) => product.id == productId);
      _list.removeWhere((product) => product.id == productId);
      notifyListeners();

      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _list.insert(productIndex, deletingProduct);
        notifyListeners();

        throw HttpException('Mahsulot o\'chirishda xatolik');
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Product> get favorites {
    return _list.where((product) => product.isLike).toList();
  }

  List<Product> get list {
    return [..._list];
  }
}
