import 'dart:convert';
import 'package:silkroute/model/core/Bill.dart';
import 'package:silkroute/model/core/CrateListItem.dart';

class OrderListItem {
  final String id;
  final CrateListItem item;
  final String latestStatus;
  final String address;
  final Map<String, dynamic> status;
  final num ratingGiven;
  final List colors;
  final num reviewGiven;
  final Bill bill;

  OrderListItem({
    this.id,
    this.item,
    this.colors,
    this.address,
    this.latestStatus,
    this.status,
    this.ratingGiven,
    this.reviewGiven,
    this.bill,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item.toMap(),
      'address': address,
      'colors': colors,
      'latestStatus': latestStatus,
      'status': status,
      'ratingGiven': ratingGiven,
      'reviewGiven': reviewGiven,
      'bill': bill.toMap(),
    };
  }

  factory OrderListItem.fromMap(Map<String, dynamic> map) {
    return OrderListItem(
      id: map['id'],
      item: CrateListItem.fromMap(map['item']),
      latestStatus: map['latestStatus'],
      address: map['address'],
      colors: map['colors'],
      status: Map<String, dynamic>.from(map['status']),
      ratingGiven: map['ratingGiven'],
      reviewGiven: map['reviewGiven'],
      bill: Bill.fromMap(map['bill']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderListItem.fromJson(String source) =>
      OrderListItem.fromMap(json.decode(source));
}
