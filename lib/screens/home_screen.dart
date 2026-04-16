import 'package:flutter/material.dart';
import 'package:productes_app/models/models.dart';
import 'package:productes_app/screens/screens.dart';
import 'package:productes_app/services/services.dart';
import 'package:productes_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productes'),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: ProductCard(
            product: productsService.products[index],
          ),
          onTap: () {
            productsService.newPicture =
                null; // Lo ponemos aquí para que se reinicie la nueva imagen a null y no cambiar si modificamos otro dato de producto.
            // Crear una instancia copia de un producto y con el onTap nos lleva al producto (asi no se modifica el producto de la base de datos)
            productsService.selectedProduct =
                productsService.products[index].copy();
            Navigator.of(context).pushNamed('product');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productsService.newPicture =
              null; // Lo ponemos aquí para que se reinicie la nueva imagen a null y no cambiar si modificamos otro dato de producto.
          productsService.selectedProduct =
              Product(available: true, name: '', price: 0);
          Navigator.of(context).pushNamed('product');
        },
      ),
    );
  }
}
