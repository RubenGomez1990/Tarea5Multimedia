import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productes_app/providers/login_form_provider.dart';
import 'package:productes_app/ui/input_decorations.dart';
import 'package:productes_app/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Crear compte',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),

                    // Inicializamos el Provider configurado para REGISTRO
                    ChangeNotifierProvider(
                      create: (_) {
                        final provider = LoginFormProvider();
                        provider.isLogin = false; // Apagamos el login
                        provider.isRegister = true; // Encendemos el registro
                        return provider;
                      },
                      child: _RegisterForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // Botón para volver al Login si ya tiene cuenta
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.indigo),
                  shape: WidgetStateProperty.all(const StadiumBorder()),
                ),
                child: const Text(
                  'Ja tens un compte? Inicia sessió',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm
            .formKey, // Ponemos la llave necesaria para hacer referencia al formulario
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // Campo Email
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'ejemplo@correo.com',
                labelText: 'Correu electrònic',
                prefixIcon: Icons.alternate_email_outlined,
              ),
              onChanged: (value) => loginForm.email =
                  value, // Aqui recoge los datos y actualizar los datos del provider
              validator: (value) {
                // IMPORTANTE: Aqui es donde validamos el REGEX para comprobar que tenga formato de email.
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'Correu no vàlid';
              },
            ),

            const SizedBox(height: 30),

            // Campo Password
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Contrasenya',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'Mínim 6 caràcters';
              },
            ),

            const SizedBox(height: 30),

            // Botón de Registro
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!loginForm.isValidForm())
                        return; // Aqui comprobamos que los valores son válidos

                      await loginForm
                          .loginOrRegister(); // Y aqui finalmente se mandan a la base de datos los valores comprobados y validados.

                      if (loginForm.errorMessage.isEmpty) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        // Aquí podrías mostrar el error de Firebase
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loginForm.errorMessage)));
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Esperi...' : 'Crear compte',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
