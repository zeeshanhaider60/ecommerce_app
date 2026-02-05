import '../../domain/entities/cart.dart';

class CartModel extends Cart {
  const CartModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      products:
          (json['products'] as List? ?? [])
              .map((e) => CartItemModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'products': products.map((e) => (e as CartItemModel).toJson()).toList(),
    };
  }
}

class CartItemModel extends CartItem {
  final String? title;
  final double? price;
  final String? image;
  final String? description;
  final String? category;

  const CartItemModel({
    required super.productId,
    required super.quantity,
    this.title,
    this.price,
    this.image,
    this.description,
    this.category,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] ?? json['id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      title: json['title'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      image: json['image'],
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      if (title != null) 'title': title,
      if (price != null) 'price': price,
      if (image != null) 'image': image,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
    };
  }

  CartItemModel copyWith({
    int? productId,
    int? quantity,
    String? title,
    double? price,
    String? image,
    String? description,
    String? category,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }

  // Calculates total price for the item
  double get totalPrice => (price ?? 0) * quantity;
}
