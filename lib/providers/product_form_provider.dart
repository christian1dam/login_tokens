import 'package:login_tokens/models/product.dart';
import 'package:flutter/material.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;
  TextEditingController fechaRegistroController = TextEditingController();

  ProductFormProvider(this.product) {
    if (product.fechaRegistro != null) {
      fechaRegistroController.text =
          '${product.fechaRegistro!.day}/${product.fechaRegistro!.month}/${product.fechaRegistro!.year}';
    }
  }

  bool isValidForm() {
    print(product.name);
    print(product.price);
    print(product.available);
    print(product.fechaRegistro);
    return formKey.currentState?.validate() ?? false;
  }

  updateAvailability(bool value) {
    product.available = value;

    notifyListeners();
  }

  set fechaRegistro(DateTime? date) {
      product.fechaRegistro = date;
    if (date != null) {
      fechaRegistroController.text = '${date.day}/${date.month}/${date.year}';
    }
    notifyListeners();
  }
}
