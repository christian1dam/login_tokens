import 'package:flutter/material.dart';
import 'package:login_tokens/models/product.dart';
import 'package:login_tokens/providers/product_form_provider.dart';
import 'package:login_tokens/services/products_service.dart';
import 'package:login_tokens/ui/input_decorations.dart';

import 'package:login_tokens/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductScreenBody(productService: productsService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductsService productService;

  const _ProductScreenBody({required this.productService});

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productForm.product.picture,
                ),
                _volverAtrasIcon(context),
                _cameraIcon(productForm),
                Positioned(
                  top: 60,
                  right: 80,
                  child: IconButton(
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: productService.isSaving
                        ? null
                        : () async {
                            await _processImage('gallery');
                            if (productForm.isValidForm()) {
                              final String? imageUrl =
                                  await productService.uploadImage();
                              if (imageUrl != null)
                                productForm.product.picture = imageUrl;
                            }
                          },
                  ),
                )
              ],
            ),
            ProductForm(
              product: productService.selectedProduct,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!productForm.isValidForm()) return;
          await productService.saveOrUpdateProduct(productForm.product);
        },
        child: productService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(
                Icons.save_outlined,
                color: Colors.white,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Positioned _cameraIcon(ProductFormProvider productForm) {
    return Positioned(
      top: 60,
      right: 20,
      child: IconButton(  
        onPressed: productService.isSaving
            ? null
            : () async {
                await _processImage("camera");
                if (productForm.isValidForm()) {
                  final String? imageUrl = await productService.uploadImage();
                  if (imageUrl != null) productForm.product.picture = imageUrl;
                }
              },
        icon: const Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Positioned _volverAtrasIcon(BuildContext context) {
    return Positioned(
      top: 60,
      left: 20,
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Future<void> _processImage(String source) async {
    final picker = ImagePicker();
    late XFile? pickedFile;

    if (source == "camera") {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
    } else {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
    }

    if (pickedFile == null) {
      print("no se ha seleccionado nada");
    } else {
      print("tenemos imagen: ${pickedFile.path}");
      productService.updateSelectedProductImage(pickedFile.path);
    }
  }
}

class ProductForm extends StatelessWidget {
  final Product product;

  const ProductForm({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: _productFormDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'el nombre es obligatorio';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: '${product.price}',
                onChanged: (value) {
                  if (value.isEmpty) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '150€',
                  labelText: 'Precio',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: productForm.fechaRegistroController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    productForm.fechaRegistro = pickedDate;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduce la fecha de registro';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'dd/mm/aaaa',
                  labelText: 'Fecha de registro',
                  prefixIcon: Icons.calendar_today,
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile.adaptive(
                value: product.available,
                title: const Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value) => productForm.updateAvailability(value),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _productFormDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5)
      ],
    );
  }
}
