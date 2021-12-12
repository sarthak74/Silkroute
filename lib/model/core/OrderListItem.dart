import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class OrderListItem {
  final String contact;
  final Bill bill;
  final String status;
  final dynamic address;
  final String uniqueId;
  final String invoiceNumber;
  final String customerPaymentStatus;
  final dynamic createdDate;
  final dynamic razorpay;
  final List<dynamic> items;
  final String title;
  OrderListItem({
    this.contact,
    this.bill,
    this.status,
    this.address,
    this.uniqueId,
    this.invoiceNumber,
    this.customerPaymentStatus,
    this.createdDate,
    this.razorpay,
    this.items,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'contact': contact,
      'bill': bill.toMap(),
      'status': status,
      'address': address,
      'uniqueId': uniqueId,
      'invoiceNumber': invoiceNumber,
      'customerPaymentStatus': customerPaymentStatus,
      'createdDate': createdDate,
      'razorpay': razorpay,
      'items': items,
      'title': title,
    };
  }

  factory OrderListItem.fromMap(Map<String, dynamic> map) {
    return OrderListItem(
      contact: map['contact'] ?? '',
      bill: Bill.fromMap(map['bill']),
      status: map['status'] ?? '',
      address: map['address'] ?? null,
      uniqueId: map['uniqueId'] ?? '',
      invoiceNumber: map['invoiceNumber'] ?? '',
      customerPaymentStatus: map['customerPaymentStatus'] ?? '',
      createdDate: map['createdDate'] ?? null,
      razorpay: map['razorpay'] ?? null,
      items: List<dynamic>.from(map['items']),
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderListItem.fromJson(String source) =>
      OrderListItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderListItem(contact: $contact, bill: $bill, status: $status, address: $address, uniqueId: $uniqueId, invoiceNumber: $invoiceNumber, customerPaymentStatus: $customerPaymentStatus, createdDate: $createdDate, razorpay: $razorpay, items: $items, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is OrderListItem &&
        other.contact == contact &&
        other.bill == bill &&
        other.status == status &&
        other.address == address &&
        other.uniqueId == uniqueId &&
        other.invoiceNumber == invoiceNumber &&
        other.customerPaymentStatus == customerPaymentStatus &&
        other.createdDate == createdDate &&
        other.razorpay == razorpay &&
        listEquals(other.items, items) &&
        other.title == title;
  }

  @override
  int get hashCode {
    return contact.hashCode ^
        bill.hashCode ^
        status.hashCode ^
        address.hashCode ^
        uniqueId.hashCode ^
        invoiceNumber.hashCode ^
        customerPaymentStatus.hashCode ^
        createdDate.hashCode ^
        razorpay.hashCode ^
        items.hashCode ^
        title.hashCode;
  }
}
