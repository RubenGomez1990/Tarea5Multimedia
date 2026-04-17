import 'package:flutter/material.dart';
import 'package:productes_app/models/models.dart';
import 'package:productes_app/providers/login_form_provider.dart';
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
        actions: [
          IconButton(
              icon: const Icon(Icons.logout_outlined),
              tooltip: 'Tancar sessió',
              onPressed: () {
                //Accedemos al Provider (listen: false porque estamos en un botón, no dibujando)
                final loginForm =
                    Provider.of<LoginFormProvider>(context, listen: false);
                //Limpiamos las variables del Provider
                loginForm.logOut();
                //Destruimos la pantalla de productos y volvemos al Login
                Navigator.pushReplacementNamed(context, 'login');
              }),
        ],
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
