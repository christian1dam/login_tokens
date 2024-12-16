import 'dart:convert';

class Product {
  bool available;
  String name;
  String? picture;
  double price;
  String? id;
  DateTime? fechaRegistro;

  Product({
    required this.available,
    required this.name,
    this.picture,
    required this.price,
    this.id,
    this.fechaRegistro,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"]?.toDouble(),
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
        "fechaRegistro": fechaRegistro?.toIso8601String(),
      };

// Deep copy para evitar la copia por referencia
  Product copy() => Product(
        available: available,
        name: name,
        picture: picture,
        price: price,
        id: id,
        fechaRegistro: fechaRegistro,
      );
}
