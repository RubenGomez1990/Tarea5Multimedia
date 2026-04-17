import 'package:flutter/material.dart';
import 'package:productes_app/providers/login_form_provider.dart';
import 'package:productes_app/screens/product_screen.dart';
import 'package:productes_app/screens/register_screen.dart';
import 'package:productes_app/screens/screens.dart';
import 'package:productes_app/services/products_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // <-- Import obligatorio
import 'firebase_options.dart';

void main() async {
  //Obligatorio si vamos a ejecutar código asíncrono antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  //Inicializamos Firebase con tus llaves oficiales
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Arrancamos tu AppState
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService(), lazy: false),
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productes App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
    );
  }
}
