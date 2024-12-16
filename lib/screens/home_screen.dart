import 'package:login_tokens/screens/screens.dart';
import 'package:login_tokens/services/products_service.dart';
import 'package:login_tokens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:login_tokens/models/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => Dismissible(
          key: Key(productsService.products[index].id!),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            final confirmarEliminacion = await showDialog<bool>(
              context: context,
              builder: (context) => _confirmarEliminarProducto(context),
            );

            if (confirmarEliminacion == true) {
              productsService.deleteProduct(productsService.products[index]);
            }
          },
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ProductoCard(
            productsService: productsService,
            product: productsService.products[index],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsService.selectedProduct = Product(
            available: false,
            price: 0,
            name: '',
          );
          Navigator.pushNamed(context, 'productScreen');
        },
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  AlertDialog _confirmarEliminarProducto(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar eliminación'),
      content:
          const Text('¿Estás seguro de que quieres eliminar este producto?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
