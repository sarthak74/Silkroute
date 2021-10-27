import 'dart:convert';

class CrateListItem {
  final String id;
  final String title;
  final bool discount;
  final num mrp;
  final num discountValue;
  final num quantity;
  final List<dynamic> colors;
  final num stock;

  CrateListItem({
    this.id,
    this.title,
    this.discount,
    this.mrp,
    this.discountValue,
    this.quantity,
    this.colors,
    this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'discount': discount,
      'mrp': mrp,
      'discountValue': discountValue,
      'quantity': quantity,
      'colors': colors,
      'stock': stock,
    };
  }

  factory CrateListItem.fromMap(Map<String, dynamic> map) {
    return CrateListItem(
      id: map['id'],
      title: map['title'],
      discount: map['discount'],
      mrp: map['mrp'],
      discountValue: map['discountValue'],
      quantity: map['quantity'],
      colors: map['colors'],
      stock: map['stock'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CrateListItem.fromJson(String source) =>
      CrateListItem.fromMap(json.decode(source));
}
