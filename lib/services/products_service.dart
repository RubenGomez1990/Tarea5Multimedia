import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productes_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-multimedia-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = true;

  ProductsService() {
    loadProducts();
  }
  // Método para cargar los productos
  Future loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
    final response = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(response.body);

    //Recorre cada producto y los añade
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final response = await http.put(url, body: product.toRawJson());
    final decodedData = response.body;
    print(decodedData);

    // Busca el indice exacto en nuestra lista local usando indexWhere y donde el element.id sea igual al id del producto devuelve su posición.
    final index = products.indexWhere((element) => element.id == product.id);
    // Y en esa posición, coge el producto modificado y sobrescribe la versión antigua
    products[index] = product;
    // Notifica el cambio
    notifyListeners();
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url =
        Uri.https(_baseUrl, 'products.json'); // La url apunta a la lista
    //Dado que Quicktype es más moderno ahora, usamos toRawJson para que devuelve codificado en String el mapa recibido.
    final response = await http.post(url, body: product.toRawJson());
    final decodedData =
        json.decode(response.body); // decodificamos la respuesta

    product.id = decodedData[
        'name']; // Al nuevo producto le asignamos el ID para Firebase
    products.add(product); // Añadimos a la lista
    notifyListeners(); // Notificamos
    return product.id!;
  }
}
