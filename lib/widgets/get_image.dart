import 'package:flutter/material.dart';
import 'dart:io';

class GetImage extends StatelessWidget {
  final String? image;

  const GetImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const Image(
        image: AssetImage('lib/assets/no-image.png'),
        fit: BoxFit.cover,
      );
    }

    if (image!.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('lib/assets/jar-loading.gif'),
        image: NetworkImage(image!),
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(image!),
      fit: BoxFit.cover,
    );
  }
}
