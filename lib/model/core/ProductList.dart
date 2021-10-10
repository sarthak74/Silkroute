import 'dart:convert';

/*
id: String,
title: String,
category: String,
userContact: String,
dateAdded: String,
description: String,
mrp: Number,
discount: Boolean,
discountValue: Number,
totalSet: Number,
min: Number,
increment: Number,
stockAvailability: Number,
resellerCrateAvailability: Number,
colors: Object
*/
class ProductList {
  final String id;
  final String title;
  final bool discount;
  final num mrp;
  final num discountValue;
  final String category;
  final String userContact;
  final String dateAdded;
  final String description;
  final num totalSet;
  final num min;
  final num increment;
  final num stockAvailability;
  final num resellerCrateAvailability;
  final dynamic colors;

  ProductList({
    this.id,
    this.title,
    this.discount,
    this.mrp,
    this.discountValue,
    this.category,
    this.userContact,
    this.dateAdded,
    this.description,
    this.totalSet,
    this.min,
    this.increment,
    this.stockAvailability,
    this.resellerCrateAvailability,
    this.colors,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'discount': discount,
      'mrp': mrp,
      'discountValue': discountValue,
      'category': category,
      'userContact': userContact,
      'dateAdded': dateAdded,
      'description': description,
      'totalSet': totalSet,
      'min': min,
      'increment': increment,
      'stockAvailability': stockAvailability,
      'resellerCrateAvailability': resellerCrateAvailability,
      'colors': colors,
    };
  }

  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      id: map['id'],
      title: map['title'],
      discount: map['discount'],
      mrp: map['mrp'],
      discountValue: map['discountValue'],
      category: map['category'],
      userContact: map['userContact'],
      dateAdded: map['dateAdded'],
      description: map['description'],
      totalSet: map['totalSet'],
      min: map['min'],
      increment: map['increment'],
      stockAvailability: map['stockAvailability'],
      resellerCrateAvailability: map['resellerCrateAvailability'],
      colors: map['colors'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductList.fromJson(String source) =>
      ProductList.fromMap(json.decode(source));
}
