import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool isValidForm() {
    print('Valor del formulari: ${formKey.currentState?.validate()}');
    print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userLogged;
  User? user;

  // Variables de estado para que distinga entre un registro y un login
  bool isLogin = true;
  bool isRegister = false;
  String errorMessage = '';

  bool accesGranted = false;

  // Captura el estado de carga para bloquear el botón y evitar múltiples peticiones
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Método para cambiar el modo de pantalla en el login/registro
  void toggleMode() {
    isLogin = !isLogin;
    isRegister = !isRegister;
    errorMessage = ''; // Importante limpiar errores al cambio de pantalla
    notifyListeners();
  }

  // Método que hará un login o un registro con condicionales.
  Future<void> loginOrRegister() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      if (isRegister) {
        userLogged = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else if (isLogin) {
        userLogged = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      user = userLogged!.user;
    } on FirebaseAuthException catch (error) {
      errorMessage = getMessageFromErrorCode(error);
    }

    isLoading = false;
    accesGranted = user != null;
    notifyListeners();
  }

  // Método para desloguear de la aplicación
  void logOut() {
    userLogged = null;
    accesGranted = false;
    isLogin = true; // Al cerrar sesión volvemos al estado inicial
    isRegister = false;
    errorMessage = '';
    user = null;
    notifyListeners();
  }

  bool get isLoginOrRegister {
    return isLogin || isRegister;
  }

  // Traductor de errores posibles.
  String getMessageFromErrorCode(FirebaseAuthException errorCode) {
    switch (errorCode.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "El correo ya está en uso. Ve a iniciar sesión.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Combinación de correo/contraseña incorrecta.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No se ha encontrado ningún usuario con este correo.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Usuario deshabilitado.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Demasiados intentos. Inténtalo más tarde.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "La dirección de correo no es válida.";
      case "INVALID_LOGIN_CREDENTIALS":
        return "Credenciales inválidas.";
      default:
        return "Fallo en la autenticación. Inténtalo de nuevo.";
    }
  }
}
