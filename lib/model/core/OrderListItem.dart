import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class OrderListItem {
  final String id;
  final List<CrateListItem> items;
  final String latestStatus;
  final dynamic address;
  final Map<String, dynamic> status;
  final num ratingGiven;
  final dynamic reviewGiven;
  final Bill bill;
  final String title;
  final dynamic dispatchDate;
  final String invoiceNumber;
  final String paymentStatus;
  OrderListItem({
    this.id,
    this.items,
    this.latestStatus,
    this.address,
    this.status,
    this.ratingGiven,
    this.reviewGiven,
    this.bill,
    this.title,
    this.dispatchDate,
    this.invoiceNumber,
    this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': items.map((item) => item.toMap()),
      'latestStatus': latestStatus,
      'address': address,
      'status': status,
      'ratingGiven': ratingGiven,
      'reviewGiven': reviewGiven,
      'bill': bill.toMap(),
      'title': title,
      'dispathDate': dispatchDate,
      'invoiceNumber': invoiceNumber,
      'paymentStatus': paymentStatus,
    };
  }

  factory OrderListItem.fromMap(Map<String, dynamic> map) {
    return OrderListItem(
      id: map['id'],
      items: map['items'].map((item) => item.fromMap()),
      latestStatus: map['latestStatus'],
      address: map['address'],
      status: Map<String, dynamic>.from(map['status']),
      ratingGiven: map['ratingGiven'],
      reviewGiven: map['reviewGiven'],
      bill: Bill.fromMap(map['bill']),
      title: map['title'],
      dispatchDate: map['dispatchDate'],
      invoiceNumber: map['invoiceNumber'],
      paymentStatus: map['paymentStatus'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderListItem.fromJson(String source) =>
      OrderListItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderListItem(id: $id, item: $items, latestStatus: $latestStatus, address: $address, status: $status, ratingGiven: $ratingGiven, reviewGiven: $reviewGiven, bill: $bill, title: $title, dispatchDate: $dispatchDate, invoiceNumber: $invoiceNumber, paymentStatus: $paymentStatus)';
  }
}
