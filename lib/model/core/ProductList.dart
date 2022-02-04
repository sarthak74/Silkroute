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
  final String reference;
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
  final dynamic fullSetSize;
  final double fullSetPrice;
  final dynamic colors;
  final dynamic specifications;
  ProductList({
    this.id,
    this.reference,
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
    this.fullSetSize,
    this.fullSetPrice,
    this.colors,
    this.specifications,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reference': reference,
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
      'fullSetSize': fullSetSize,
      'fullSetPrice': fullSetPrice,
      'colors': colors,
      'specifications': specifications,
    };
  }

  factory ProductList.fromMap(Map<String, dynamic> map) {
    return ProductList(
      id: map['id'] ?? '',
      reference: map['reference'] ?? '',
      title: map['title'] ?? '',
      discount: map['discount'] ?? false,
      mrp: map['mrp'] ?? 0,
      sp: map['sp'] ?? 0,
      discountValue: map['discountValue'] ?? 0,
      category: map['category'] ?? '',
      subCat: map['subCat'] ?? null,
      userContact: map['userContact'] ?? '',
      dateAdded: map['dateAdded'] ?? '',
      description: map['description'] ?? '',
      setSize: map['totalSet'] ?? 0,
      min: map['min'] ?? 0,
      stockAvailability: map['stockAvailability'] ?? 0,
      resellerCrateAvailability: map['resellerCrateAvailability'] ?? 0,
      images: map['images'] ?? null,
      fullSetSize: map['fullSetSize'] ?? null,
      fullSetPrice: map['fullSetPrice']?.toDouble() ?? 0.0,
      colors: map['colors'] ?? null,
      specifications: map['specifications'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductList.fromJson(String source) =>
      ProductList.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductList(id: $id, reference: $reference, title: $title, discount: $discount, mrp: $mrp, sp: $sp, discountValue: $discountValue, category: $category, subCat: $subCat, userContact: $userContact, dateAdded: $dateAdded, description: $description, setSize: $setSize, min: $min, stockAvailability: $stockAvailability, resellerCrateAvailability: $resellerCrateAvailability, images: $images, fullSetSize: $fullSetSize, fullSetPrice: $fullSetPrice, colors: $colors, specifications: $specifications)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductList &&
        other.id == id &&
        other.reference == reference &&
        other.title == title &&
        other.discount == discount &&
        other.mrp == mrp &&
        other.sp == sp &&
        other.discountValue == discountValue &&
        other.category == category &&
        other.subCat == subCat &&
        other.userContact == userContact &&
        other.dateAdded == dateAdded &&
        other.description == description &&
        other.setSize == setSize &&
        other.min == min &&
        other.stockAvailability == stockAvailability &&
        other.resellerCrateAvailability == resellerCrateAvailability &&
        other.images == images &&
        other.fullSetSize == fullSetSize &&
        other.fullSetPrice == fullSetPrice &&
        other.colors == colors &&
        other.specifications == specifications;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        reference.hashCode ^
        title.hashCode ^
        discount.hashCode ^
        mrp.hashCode ^
        sp.hashCode ^
        discountValue.hashCode ^
        category.hashCode ^
        subCat.hashCode ^
        userContact.hashCode ^
        dateAdded.hashCode ^
        description.hashCode ^
        setSize.hashCode ^
        min.hashCode ^
        stockAvailability.hashCode ^
        resellerCrateAvailability.hashCode ^
        images.hashCode ^
        fullSetSize.hashCode ^
        fullSetPrice.hashCode ^
        colors.hashCode ^
        specifications.hashCode;
  }
}
