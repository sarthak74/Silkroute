import 'dart:convert';

import 'package:collection/collection.dart';
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
  final dynamic createdDate;
  final String invoiceNumber;
  final String paymentStatus;
  final String shipment_id;
  final String shiprocket_order_id;
  final dynamic dispatchDate;
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
    this.createdDate,
    this.invoiceNumber,
    this.paymentStatus,
    this.shipment_id,
    this.shiprocket_order_id,
    this.dispatchDate,
  });

  OrderListItem copyWith({
    String id,
    List<dynamic> items,
    String latestStatus,
    dynamic address,
    Map<String, dynamic> status,
    num ratingGiven,
    dynamic reviewGiven,
    Bill bill,
    String title,
    dynamic createdDate,
    String invoiceNumber,
    String paymentStatus,
    String shipment_id,
    String shiprocket_order_id,
    dynamic dispatchDate,
  }) {
    return OrderListItem(
      id: id ?? this.id,
      items: items ?? this.items,
      latestStatus: latestStatus ?? this.latestStatus,
      address: address ?? this.address,
      status: status ?? this.status,
      ratingGiven: ratingGiven ?? this.ratingGiven,
      reviewGiven: reviewGiven ?? this.reviewGiven,
      bill: bill ?? this.bill,
      title: title ?? this.title,
      createdDate: createdDate ?? this.createdDate,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      shipment_id: shipment_id ?? this.shipment_id,
      shiprocket_order_id: shiprocket_order_id ?? this.shiprocket_order_id,
      dispatchDate: dispatchDate ?? this.dispatchDate,
    );
  }

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
      'createdDate': createdDate,
      'invoiceNumber': invoiceNumber,
      'paymentStatus': paymentStatus,
      'shipment_id': shipment_id,
      'shiprocket_order_id': shiprocket_order_id,
      'dispatchDate': dispatchDate,
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
      createdDate: map['createdDate'],
      invoiceNumber: map['invoiceNumber'],
      paymentStatus: map['paymentStatus'],
      shipment_id: map['shipment_id'],
      shiprocket_order_id: map['shiprocket_order_id'],
      dispatchDate: map['dispatchDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderListItem.fromJson(String source) =>
      OrderListItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderListItem(id: $id, items: $items, latestStatus: $latestStatus, address: $address, status: $status, ratingGiven: $ratingGiven, reviewGiven: $reviewGiven, bill: $bill, title: $title, createdDate: $createdDate, invoiceNumber: $invoiceNumber, paymentStatus: $paymentStatus, shipment_id: $shipment_id, shiprocket_order_id: $shiprocket_order_id, dispatchDate: $dispatchDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other is OrderListItem &&
        other.id == id &&
        collectionEquals(other.items, items) &&
        other.latestStatus == latestStatus &&
        other.address == address &&
        collectionEquals(other.status, status) &&
        other.ratingGiven == ratingGiven &&
        other.reviewGiven == reviewGiven &&
        other.bill == bill &&
        other.title == title &&
        other.createdDate == createdDate &&
        other.invoiceNumber == invoiceNumber &&
        other.paymentStatus == paymentStatus &&
        other.shipment_id == shipment_id &&
        other.shiprocket_order_id == shiprocket_order_id &&
        other.dispatchDate == dispatchDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        items.hashCode ^
        latestStatus.hashCode ^
        address.hashCode ^
        status.hashCode ^
        ratingGiven.hashCode ^
        reviewGiven.hashCode ^
        bill.hashCode ^
        title.hashCode ^
        createdDate.hashCode ^
        invoiceNumber.hashCode ^
        paymentStatus.hashCode ^
        shipment_id.hashCode ^
        shiprocket_order_id.hashCode ^
        dispatchDate.hashCode;
  }
}
