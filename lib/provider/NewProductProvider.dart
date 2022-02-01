import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class NewProductProvider {
  static String reference = "";
  static String title = "";
  static String subCat = "";
  static String description = "";
  static int setSize = 0;
  static String category = "";
  static int stockAvailability = 0;
  static List<dynamic> colors = [];
  static List<dynamic> images = [];
  static int min = 0;
  static double halfSetPrice = 0.0;
  static double fullSetPrice = 0.0;
  static dynamic specifications = [];
  static List<dynamic> editColors = [];
  static List<dynamic> editImages = [];

  static dynamic fullSetSize = {"L": 0.0, "B": 0.0, "H": 0.0};
}

/*
Map<String, dynamic> data = {
        "title": NewProductProvider.title,
        "category": NewProductProvider.category,
        "subCat": NewProductProvider.specifications[0]["value"],
        "mrp": NewProductProvider.fullSetPrice,
        'discountValue': 0,
        'userContact': storage.getItem("contact"),
        'description': NewProductProvider.description,
        'setSize': NewProductProvider.setSize,
        'min': NewProductProvider.min,
        'stockAvailability': NewProductProvider.stockAvailability,
        'resellerCrateAvailability': 0,
        'images': NewProductProvider.images,
        'halfSetPrice': NewProductProvider.halfSetPrice,
        'fullSetPrice': NewProductProvider.fullSetPrice,
        'colors': NewProductProvider.colors,
        'specifications': NewProductProvider.specifications.slice(1, 5),
      };


*/