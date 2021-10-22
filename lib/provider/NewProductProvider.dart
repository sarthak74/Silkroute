import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class NewProductProvider {
  static List<File> images = [];
  static String title = "";
  static String description = "";
  static int setSize = 0;
  static String category = "";
  static int stockAvailability = 0;
  static List<File> colors = [];
  static int min = 0;
  static double halfSetPrice = 0.0;
  static double fullSetPrice = 0.0;
  static dynamic specifications = [];
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