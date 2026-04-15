import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productes_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-multimedia-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];

  bool isLoading = true;

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(response.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
  }
}
