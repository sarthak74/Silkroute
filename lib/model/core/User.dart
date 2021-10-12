import 'dart:convert';
import 'package:silkroute/model/core/CrateListItem.dart';
import 'package:silkroute/model/core/ProductList.dart';

class User {
  final String name;
  final String picUrl;
  final String userType;
  final String businessAddress;
  final String gstin;
  final String email;
  final bool registered;
  final num contact;
  final num altContact;

  User({
    this.name,
    this.picUrl,
    this.userType,
    this.businessAddress,
    this.gstin,
    this.email,
    this.registered,
    this.contact,
    this.altContact,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'picUrl': picUrl,
      'userType': userType,
      'businessAddress': businessAddress,
      'gstin': gstin,
      'email': email,
      'registered': registered,
      'contact': contact,
      'altContact': altContact,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      picUrl: map['picUrl'],
      userType: map['userType'],
      businessAddress: map['businessAddress'],
      gstin: map['gstin'],
      email: map['email'],
      registered: map['registered'],
      contact: map['contact'],
      altContact: map['altContact'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class Reseller extends User {
  final List<ProductList> wishlist;
  final List<CrateListItem> crate;
  final List<String> altAddresses;
  final List<Map<String, String>> referrals;
  Reseller({
    this.wishlist,
    this.crate,
    this.altAddresses,
    this.referrals,
  });

  Map<String, dynamic> toMap() {
    return {
      'wishlist': wishlist?.map((x) => x.toMap())?.toList(),
      'crate': crate?.map((x) => x.toMap())?.toList(),
      'altAddresses': altAddresses,
      'referrals': referrals,
    };
  }

  factory Reseller.fromMap(Map<String, dynamic> map) {
    return Reseller(
      wishlist: List<ProductList>.from(
          map['wishlist']?.map((x) => ProductList.fromMap(x))),
      crate: List<CrateListItem>.from(
          map['crate']?.map((x) => CrateListItem.fromMap(x))),
      altAddresses: List<String>.from(map['altAddresses']),
      referrals:
          List<Map<String, String>>.from(map['referrals']?.map((x) => x)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Reseller.fromJson(String source) =>
      Reseller.fromMap(json.decode(source));
}

class Merchant extends User {
  final List<ProductList> myProducts;
  final List<ProductList> myDrafts;
  final dynamic myDashboard;
  final dynamic myOrders;
  final Map<String, String> bankAccount;
  final String loomAddress;
  final String loomCertificateID;
  Merchant({
    this.myProducts,
    this.myDrafts,
    this.myDashboard,
    this.myOrders,
    this.bankAccount,
    this.loomAddress,
    this.loomCertificateID,
  });

  Map<String, dynamic> toMap() {
    return {
      'myProducts': myProducts?.map((x) => x.toMap())?.toList(),
      'myDrafts': myDrafts?.map((x) => x.toMap())?.toList(),
      'myDashboard': myDashboard,
      'myOrders': myOrders,
      'bankAccount': bankAccount,
      'loomAddress': loomAddress,
      'loomCertificateID': loomCertificateID,
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      myProducts: List<ProductList>.from(
          map['myProducts']?.map((x) => ProductList.fromMap(x))),
      myDrafts: List<ProductList>.from(
          map['myDrafts']?.map((x) => ProductList.fromMap(x))),
      myDashboard: map['myDashboard'],
      myOrders: map['myOrders'],
      bankAccount: Map<String, String>.from(map['bankAccount']),
      loomAddress: map['loomAddress'],
      loomCertificateID: map['loomCertificateID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Merchant.fromJson(String source) =>
      Merchant.fromMap(json.decode(source));
}
