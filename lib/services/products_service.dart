import 'package:flutter/material.dart';
import 'package:productes_app/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-multimedia-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
}
