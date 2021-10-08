import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:localstorage/localstorage.dart';

// import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic(this.contact);
  final String contact;
  ProfilePicState createState() => new ProfilePicState();
}

class ProfilePicState extends State<ProfilePic> {
  LocalStorage storage = LocalStorage('silkroute');

  @override
  void initState() {
    developer.log("message");
    super.initState();
  }

  // File _image;

  // pickImage() async {
  //   File image = await ImagePicker.pickImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 100,
  //     maxWidth: 100,
  //   );

  //   setState(() {
  //     _image = image;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // pickImage();
                  // print("abcd");
                  Navigator.of(context).pushNamed("/reseller_profile");
                },
                child: Image.network(
                  'https://static.thenounproject.com/png/3237155-200.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
