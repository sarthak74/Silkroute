import 'dart:convert';

class Bill {
  final num totalValue;
  final num implicitDiscount;
  final num priceAfterDiscount;
  final num couponDiscount;
  final num gst;
  final num logistic;
  final num totalCost;
  Bill({
    this.totalValue,
    this.implicitDiscount,
    this.priceAfterDiscount,
    this.couponDiscount,
    this.gst,
    this.logistic,
    this.totalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalValue': totalValue,
      'implicitDiscount': implicitDiscount,
      'priceAfterDiscount': priceAfterDiscount,
      'couponDiscount': couponDiscount,
      'gst': gst,
      'logistic': logistic,
      'totalCost': totalCost,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      totalValue: map['totalValue'],
      implicitDiscount: map['implicitDiscount'],
      priceAfterDiscount: map['priceAfterDiscount'],
      couponDiscount: map['couponDiscount'],
      gst: map['gst'],
      logistic: map['logistic'],
      totalCost: map['totalCost'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source));
}
