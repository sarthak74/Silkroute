import 'dart:convert';

import 'package:flutter/cupertino.dart';

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
  final num sp;
  final num discountValue;
  final String category;
  final dynamic subCat;
  final String userContact;
  final String dateAdded;
  final String description;
  final num setSize;
  final num min;
  final num stockAvailability;
  final num resellerCrateAvailability;
  final dynamic images;
  final double halfSetPrice;
  final double fullSetPrice;
  final dynamic colors;
  final dynamic specifications;
  ProductList({
    this.id,
    this.title,
    this.discount,
    this.mrp,
    this.sp,
    this.discountValue,
    this.category,
    this.subCat,
    this.userContact,
    this.dateAdded,
    this.description,
    this.setSize,
    this.min,
    this.stockAvailability,
    this.resellerCrateAvailability,
    this.images,
    this.halfSetPrice,
    this.fullSetPrice,
    this.colors,
    this.specifications,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'discount': discount,
      'mrp': mrp,
      'sp': sp,
      'discountValue': discountValue,
      'category': category,
      'subCat': subCat,
      'userContact': userContact,
      'dateAdded': dateAdded,
      'description': description,
      'setSize': setSize,
      'min': min,
      'stockAvailability': stockAvailability,
      'resellerCrateAvailability': resellerCrateAvailability,
      'images': images,
      'halfSetPrice': halfSetPrice,
      'fullSetPrice': fullSetPrice,
      'colors': colors,
      'specifications': specifications,
    };
  }

  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      id: map['id'],
      title: map['title'],
      discount: map['discount'],
      mrp: map['mrp'],
      sp: map['sp'],
      discountValue: map['discountValue'],
      category: map['category'],
      subCat: map['subCat'],
      userContact: map['userContact'],
      dateAdded: map['dateAdded'],
      description: map['description'],
      setSize: map['setSize'],
      min: map['min'],
      stockAvailability: map['stockAvailability'],
      resellerCrateAvailability: map['resellerCrateAvailability'],
      images: map['images'],
      halfSetPrice: map['halfSetPrice'],
      fullSetPrice: map['fullSetPrice'],
      colors: map['colors'],
      specifications: map['specifications'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductList.fromJson(String source) =>
      ProductList.fromMap(json.decode(source));
}
