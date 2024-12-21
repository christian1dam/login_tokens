import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_tokens/screens/screens.dart';
import 'package:login_tokens/services/notification_service.dart';
import 'package:login_tokens/services/services.dart';
import 'package:login_tokens/ui/input_decorations.dart';
import 'package:login_tokens/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:login_tokens/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                height: 350,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ChangeNotifierProvider(
                        create: (_) => LoginFormProvider(),
                        child: _LoginForm()),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'SignUp');
                },
                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(
                    Colors.indigo.withOpacity(0.2),
                  ),
                  shape: const WidgetStatePropertyAll(
                    StadiumBorder(),
                  ),
                ),
                child: const Text(
                  "Crear una nueva cuenta",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      child: Column(
        children: [
          TextFormField(
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'introduce un email valido';
              },
              onChanged: (value) => loginForm.email = value,
              autovalidateMode: AutovalidateMode.onUnfocus,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email,
              )),
          TextFormField(
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe contener al menos 6 caracteres';
            },
            onChanged: (value) => loginForm.password = value,
            autovalidateMode: AutovalidateMode.onUnfocus,
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
                hintText: "",
                labelText: "Contraseña",
                prefixIcon: Icons.lock_outline_rounded),
          ),
          const SizedBox(height: 30),
          LoginBtn(loginForm)
        ],
      ),
    );
  }
}

class LoginBtn extends StatelessWidget {
  final LoginFormProvider loginForm;
  const LoginBtn(this.loginForm, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.deepPurple,
        onPressed: loginForm.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();

                final authService =
                    Provider.of<AuthService>(context, listen: false);

                if (!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                final String? errorMessage = await authService.login(
                    loginForm.email, loginForm.password);

                if (errorMessage == null) {
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  print(errorMessage);
                  NotificationService.showSnackbar(errorMessage);
                  loginForm.isLoading = false;
                }
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Text(
            loginForm.isLoading ? 'Espere' : 'Acceder',
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
