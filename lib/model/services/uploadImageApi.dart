import 'dart:convert';

import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
import 'package:silkroute/methods/math.dart';

class UploadImageApi {
  uploadImage(File _image, String name) async {
    var uri = Math().ip() + "/uploadImage";
    var req = http.MultipartRequest("POST", Uri.parse(uri));
    LocalStorage storage = await LocalStorage('silkroute');
    String token = await storage.getItem('token');

    req.fields.addAll({"name": name});
    req.files.add(await http.MultipartFile.fromPath("img", _image.path));
    req.headers.addAll(
        {"Content-type": "multipart/form-data", "Authorization": token});
    var res = await req.send();
  }
}
