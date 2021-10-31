import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class OrderListItem {
  final String id;
  final List<dynamic> items;
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
  final String shipment_id;
  final String shiprocket_order_id;
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
    this.shipment_id,
    this.shiprocket_order_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items,
      'latestStatus': latestStatus,
      'address': address,
      'status': status,
      'ratingGiven': ratingGiven,
      'reviewGiven': reviewGiven,
      'bill': bill.toMap(),
      'title': title,
      'dispatchDate': dispatchDate,
      'invoiceNumber': invoiceNumber,
      'paymentStatus': paymentStatus,
      'shipment_id': shipment_id,
      'shiprocket_order_id': shiprocket_order_id,
    };
  }

  factory OrderListItem.fromMap(Map<String, dynamic> map) {
    return OrderListItem(
      id: map['id'],
      items: List<dynamic>.from(map['items']),
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
      shipment_id: map['shipment_id'],
      shiprocket_order_id: map['shiprocket_order_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderListItem.fromJson(String source) =>
      OrderListItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderListItem(id: $id, items: $items, latestStatus: $latestStatus, address: $address, status: $status, ratingGiven: $ratingGiven, reviewGiven: $reviewGiven, bill: $bill, title: $title, dispatchDate: $dispatchDate, invoiceNumber: $invoiceNumber, paymentStatus: $paymentStatus, shipment_id: $shipment_id, shiprocket_order_id: $shiprocket_order_id)';
  }
}
