import 'dart:convert';

class Bill {
  Bill({
    this.totalValue,
    this.implicitDiscount,
    this.priceAfterDiscount,
    this.couponsApplied,
    this.couponDiscount,
    this.gst,
    this.logistic,
    this.totalCost,
  });

  final num totalValue;
  final num implicitDiscount;
  final num priceAfterDiscount;
  final List<dynamic> couponsApplied;
  final num couponDiscount;
  final num gst;
  final num logistic;
  final num totalCost;

  factory Bill.fromJson(String str) => Bill.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Bill.fromMap(Map<String, dynamic> json) => Bill(
        totalValue: json["totalValue"],
        implicitDiscount: json["implicitDiscount"],
        priceAfterDiscount: json["priceAfterDiscount"],
        couponsApplied:
            List<dynamic>.from(json["couponsApplied"].map((x) => x)),
        couponDiscount: json["couponDiscount"],
        gst: json["gst"],
        logistic: json["logistic"],
        totalCost: json["totalCost"],
      );

  Map<String, dynamic> toMap() => {
        "totalValue": totalValue,
        "implicitDiscount": implicitDiscount,
        "priceAfterDiscount": priceAfterDiscount,
        "couponsApplied": List<dynamic>.from(couponsApplied.map((x) => x)),
        "couponDiscount": couponDiscount,
        "gst": gst,
        "logistic": logistic,
        "totalCost": totalCost,
      };
}
