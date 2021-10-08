import 'dart:convert';

class ProductList {
  final String id;
  final String title;
  final bool discount;
  final double mrp;
  final double discountValue;
  final int minOrder;
  final bool wishlist;
  final bool rating;

  ProductList({
    this.id,
    this.title,
    this.discount,
    this.mrp,
    this.discountValue,
    this.minOrder,
    this.wishlist,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'discount': discount,
      'mrp': mrp,
      'discountValue': discountValue,
      'minOrder': minOrder,
      'wishlist': wishlist,
      'rating': rating,
    };
  }

  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      id: map['id'],
      title: map['title'],
      discount: map['discount'],
      mrp: map['mrp'],
      discountValue: map['discountValue'],
      minOrder: map['minOrder'],
      wishlist: map['wishlist'],
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductList.fromJson(String source) =>
      ProductList.fromMap(json.decode(source));
}
