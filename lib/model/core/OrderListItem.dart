import 'dart:convert';

class OrderListItem {
  final String id;
  final String title;
  final String status;
  final int ratingGiven;
  final int reviewGiven;

  OrderListItem({
    this.id,
    this.title,
    this.status,
    this.ratingGiven,
    this.reviewGiven,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'ratingGiven': ratingGiven,
      'reviewGiven': reviewGiven,
    };
  }

  factory OrderListItem.fromMap(Map<String, dynamic> map) {
    return OrderListItem(
      id: map['id'],
      title: map['title'],
      status: map['status'],
      ratingGiven: map['ratingGiven'],
      reviewGiven: map['reviewGiven'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderListItem.fromJson(String source) =>
      OrderListItem.fromMap(json.decode(source));
}
