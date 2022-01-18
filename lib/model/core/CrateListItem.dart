import 'dart:convert';

import 'package:collection/collection.dart';

class CrateListItem {
  final String id;
  final String title;
  final bool discount;
  final num mrp;
  final num discountValue;
  final num quantity;
  final String merchantContact;
  final num stock;
  final String orderId;
  final List<dynamic> colors;

  CrateListItem({
    this.id,
    this.title,
    this.discount,
    this.mrp,
    this.discountValue,
    this.quantity,
    this.merchantContact,
    this.stock,
    this.orderId,
    this.colors,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'discount': discount,
      'mrp': mrp,
      'discountValue': discountValue,
      'quantity': quantity,
      'merchantContact': merchantContact,
      'stock': stock,
      'orderId': orderId,
      'colors': colors,
    };
  }

  factory CrateListItem.fromMap(Map<String, dynamic> map) {
    return CrateListItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      discount: map['discount'] ?? false,
      mrp: map['mrp'] ?? 0,
      discountValue: map['discountValue'] ?? 0,
      quantity: map['quantity'] ?? 0,
      merchantContact: map['merchantContact'] ?? '',
      stock: map['stock'] ?? 0,
      orderId: map['orderId'] ?? '',
      colors: List<dynamic>.from(map['colors']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CrateListItem.fromJson(String source) =>
      CrateListItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CrateListItem(id: $id, title: $title, discount: $discount, mrp: $mrp, discountValue: $discountValue, quantity: $quantity, merchantContact: $merchantContact, stock: $stock, orderId: $orderId, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is CrateListItem &&
        other.id == id &&
        other.title == title &&
        other.discount == discount &&
        other.mrp == mrp &&
        other.discountValue == discountValue &&
        other.quantity == quantity &&
        other.merchantContact == merchantContact &&
        other.stock == stock &&
        other.orderId == orderId &&
        listEquals(other.colors, colors);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        discount.hashCode ^
        mrp.hashCode ^
        discountValue.hashCode ^
        quantity.hashCode ^
        merchantContact.hashCode ^
        stock.hashCode ^
        orderId.hashCode ^
        colors.hashCode;
  }
}
