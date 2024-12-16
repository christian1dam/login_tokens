import 'package:flutter/material.dart';

enum Sex { male, female}

class SignupFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String usuario = '';
  String email = '';
  String password = '';
  String phoneNumber = '';
  Sex? sex;
  DateTime? _fechaNacimiento;
  TextEditingController fechaNacimientoController = TextEditingController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  DateTime? get fechaNacimiento => _fechaNacimiento;
  
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set fechaNacimiento(DateTime? date) {
    _fechaNacimiento = date;
    if (date != null) {
      fechaNacimientoController.text = '${date.day}/${date.month}/${date.year}';
    }
    notifyListeners();
  }

  bool isValidForm() {
    print('$email - $password - $phoneNumber - $sex - $fechaNacimiento');
    print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }
}
