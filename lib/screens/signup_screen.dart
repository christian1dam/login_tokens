import 'package:flutter/material.dart';
import 'package:login_tokens/providers/providers.dart';
import 'package:login_tokens/services/notification_service.dart';
import 'package:login_tokens/services/services.dart';
import 'package:login_tokens/ui/input_decorations.dart';
import 'package:provider/provider.dart';
import 'package:login_tokens/widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                height: 660,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ChangeNotifierProvider(
                        create: (_) => SignupFormProvider(),
                        child: _SingupForm()),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'login');
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
                  "¿Ya tienes cuenta? Vuelve a Login",
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

class _SingupForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final singUpForm = Provider.of<SignupFormProvider>(context);

    return Form(
      key: singUpForm.formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              return (value!.isEmpty) ? 'El nombre no puede estar vacío' : null;
            },
            onChanged: (value) => singUpForm.usuario = value,
            autovalidateMode: AutovalidateMode.onUnfocus,
            autocorrect: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Jhon',
              labelText: 'Nombre de usuario',
              prefixIcon: Icons.person_2_outlined,
            ),
          ),
          TextFormField(
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'introduce un email valido';
            },
            onChanged: (value) => singUpForm.email = value,
            autovalidateMode: AutovalidateMode.onUnfocus,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              labelText: 'Email',
              prefixIcon: Icons.alternate_email,
            ),
          ),
          DropdownButtonFormField<Sex>(
            value: Sex.values.contains(singUpForm.sex) ? singUpForm.sex : null,
            items: Sex.values
                .map((sex) => DropdownMenuItem(
                      value: sex,
                      child: Text(sex == Sex.male ? 'Masculino' : 'Femenino'),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                singUpForm.sex = value;
              }
            },
            decoration: InputDecorations.authInputDecoration(
                hintText: "Sexo", labelText: "Sexo", prefixIcon: Icons.wc),
            validator: (value) {
              return (value == null) ? 'Por favor selecciona tu sexo' : null;
            },
          ),
          TextFormField(
            controller: singUpForm.fechaNacimientoController,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                singUpForm.fechaNacimiento = pickedDate;
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor selecciona tu fecha de nacimiento';
              }
              return null;
            },
            decoration: InputDecorations.authInputDecoration(
              hintText: 'dd/mm/aaaa',
              labelText: 'Fecha de nacimiento',
              prefixIcon: Icons.calendar_today,
            ),
          ),
          TextFormField(
            validator: (value) {
              String pattern = r'^\+?[0-9]{7,15}$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Introduce un número de teléfono válido';
            },
            onChanged: (value) => singUpForm.phoneNumber = value,
            autovalidateMode: AutovalidateMode.onUnfocus,
            autocorrect: false,
            keyboardType: TextInputType.phone,
            decoration: InputDecorations.authInputDecoration(
                hintText: '+34695204236',
                labelText: 'Número de teléfono',
                prefixIcon: Icons.phone),
          ),
          TextFormField(
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe contener al menos 6 caracteres';
            },
            onChanged: (value) => singUpForm.password = value,
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
          SignUpBtn(singUpForm)
        ],
      ),
    );
  }
}

class SignUpBtn extends StatelessWidget {
  final SignupFormProvider signUpForm;
  const SignUpBtn(this.signUpForm, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.deepPurple,
        onPressed: signUpForm.isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                if (!signUpForm.isValidForm()) return;

                final authService =
                    Provider.of<AuthService>(context, listen: false);

                signUpForm.isLoading = true;

                final String? errorMessage = await authService.createUser(
                    signUpForm.email, signUpForm.password);

                if (errorMessage == null) {
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  print(errorMessage);
                  NotificationService.showSnackbar(errorMessage);
                  signUpForm.isLoading = false;
                }
              },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Text(
            signUpForm.isLoading ? 'Espere' : 'Acceder',
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
