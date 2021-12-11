import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class MerchantOrderItem {
  final String productId;
  final String orderId;
  final String contact;
  final dynamic createdDate;
  final String title;
  final String merchantStatus;
  final String merchantPaymentStatus;
  final num quantity;
  final List<dynamic> colors;
  MerchantOrderItem({
    this.productId,
    this.orderId,
    this.contact,
    this.createdDate,
    this.title,
    this.merchantStatus,
    this.merchantPaymentStatus,
    this.quantity,
    this.colors,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'orderId': orderId,
      'contact': contact,
      'createdDate': createdDate,
      'title': title,
      'merchantStatus': merchantStatus,
      'merchantPaymentStatus': merchantPaymentStatus,
      'quantity': quantity,
      'colors': colors,
    };
  }

  factory MerchantOrderItem.fromMap(Map<String, dynamic> map) {
    return MerchantOrderItem(
      productId: map['productId'] ?? '',
      orderId: map['orderId'] ?? '',
      contact: map['contact'] ?? '',
      createdDate: map['createdDate'] ?? null,
      title: map['title'] ?? '',
      merchantStatus: map['merchantStatus'] ?? '',
      merchantPaymentStatus: map['merchantPaymentStatus'] ?? '',
      quantity: map['quantity'] ?? 0,
      colors: List<dynamic>.from(map['colors']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MerchantOrderItem.fromJson(String source) =>
      MerchantOrderItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MerchantOrderItem(productId: $productId, orderId: $orderId, contact: $contact, createdDate: $createdDate, title: $title, merchantStatus: $merchantStatus, merchantPaymentStatus: $merchantPaymentStatus, quantity: $quantity, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MerchantOrderItem &&
        other.productId == productId &&
        other.orderId == orderId &&
        other.contact == contact &&
        other.createdDate == createdDate &&
        other.title == title &&
        other.merchantStatus == merchantStatus &&
        other.merchantPaymentStatus == merchantPaymentStatus &&
        other.quantity == quantity &&
        listEquals(other.colors, colors);
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        orderId.hashCode ^
        contact.hashCode ^
        createdDate.hashCode ^
        title.hashCode ^
        merchantStatus.hashCode ^
        merchantPaymentStatus.hashCode ^
        quantity.hashCode ^
        colors.hashCode;
  }
}
