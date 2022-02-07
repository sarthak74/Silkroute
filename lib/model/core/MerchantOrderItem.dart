import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class MerchantOrderItem {
  final String productId;
  final String razorpayItemId;
  final String orderId;
  final String contact;
  final dynamic createdDate;
  final String title;
  final String merchantStatus;
  final num mrp;
  final String merchantPaymentStatus;
  final num quantity;
  final dynamic refund;
  final List<dynamic> colors;
  final dynamic shiprocket;
  MerchantOrderItem({
    this.productId,
    this.razorpayItemId,
    this.orderId,
    this.contact,
    this.createdDate,
    this.title,
    this.merchantStatus,
    this.mrp,
    this.merchantPaymentStatus,
    this.quantity,
    this.refund,
    this.colors,
    this.shiprocket,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'razorpayItemId': razorpayItemId,
      'orderId': orderId,
      'contact': contact,
      'createdDate': createdDate,
      'title': title,
      'merchantStatus': merchantStatus,
      'mrp': mrp,
      'merchantPaymentStatus': merchantPaymentStatus,
      'quantity': quantity,
      'refund': refund,
      'colors': colors,
      'shiprocket': shiprocket,
    };
  }

  factory MerchantOrderItem.fromMap(Map<String, dynamic> map) {
    return MerchantOrderItem(
      productId: map['productId'] ?? '',
      razorpayItemId: map['razorpayItemId'] ?? '',
      orderId: map['orderId'] ?? '',
      contact: map['contact'] ?? '',
      createdDate: map['createdDate'] ?? null,
      title: map['title'] ?? '',
      merchantStatus: map['merchantStatus'] ?? '',
      mrp: map['mrp'] ?? 0,
      merchantPaymentStatus: map['merchantPaymentStatus'] ?? '',
      quantity: map['quantity'] ?? 0,
      refund: map['refund'] ?? null,
      colors: List<dynamic>.from(map['colors']),
      shiprocket: map['shiprocket'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MerchantOrderItem.fromJson(String source) =>
      MerchantOrderItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MerchantOrderItem(productId: $productId, razorpayItemId: $razorpayItemId, orderId: $orderId, contact: $contact, createdDate: $createdDate, title: $title, merchantStatus: $merchantStatus, mrp: $mrp, merchantPaymentStatus: $merchantPaymentStatus, quantity: $quantity, refund: $refund, colors: $colors, shiprocket: $shiprocket)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MerchantOrderItem &&
        other.productId == productId &&
        other.razorpayItemId == razorpayItemId &&
        other.orderId == orderId &&
        other.contact == contact &&
        other.createdDate == createdDate &&
        other.title == title &&
        other.merchantStatus == merchantStatus &&
        other.mrp == mrp &&
        other.merchantPaymentStatus == merchantPaymentStatus &&
        other.quantity == quantity &&
        other.refund == refund &&
        listEquals(other.colors, colors) &&
        other.shiprocket == shiprocket;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        razorpayItemId.hashCode ^
        orderId.hashCode ^
        contact.hashCode ^
        createdDate.hashCode ^
        title.hashCode ^
        merchantStatus.hashCode ^
        mrp.hashCode ^
        merchantPaymentStatus.hashCode ^
        quantity.hashCode ^
        refund.hashCode ^
        colors.hashCode ^
        shiprocket.hashCode;
  }
}
