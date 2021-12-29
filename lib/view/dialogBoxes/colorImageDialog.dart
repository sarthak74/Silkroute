import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class ColorImageDialog extends StatefulWidget {
  const ColorImageDialog({Key key, this.images, this.selected, this.setSize})
      : super(key: key);

  final dynamic images, selected, setSize;

  @override
  _ColorImageDialogState createState() => _ColorImageDialogState();
}

class _ColorImageDialogState extends State<ColorImageDialog> {
  bool loading = false;

  void loadVars() {
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  int imagePageIndex = 0;
  PageController imagePageController = new PageController();

  void onImagePageChanged(int page) {
    print("page: $page");
    print("${widget.selected}");

    setState(() {
      imagePageIndex = page;
    });
    print("${widget.selected[imagePageIndex]}");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        width: MediaQuery.of(context).size.width * 0.85,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: SingleChildScrollView(
          child: loading
              ? Text("Loading...")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Select ${widget.setSize} pieces",
                          style: textStyle1(15, Colors.black, FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: Colors.grey,
                      child: PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          print("${widget.images[index]}");
                          // String url = widget.images[index];
                          String url =
                              "https://raw.githubusercontent.com/sarthak74/Yibrance-imgaes/master/category-Suit.png";
                          return PhotoViewGalleryPageOptions(
                            imageProvider: url == null
                                ? AssetImage("assets/images/noimage.jpg")
                                : NetworkImage(url),
                            initialScale: PhotoViewComputedScale.contained,

                            // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
                          );
                        },
                        itemCount: widget.images.length,
                        loadingBuilder: (context, event) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              value: event == null
                                  ? 0
                                  : event.cumulativeBytesLoaded /
                                      event.expectedTotalBytes,
                            ),
                          ),
                        ),
                        backgroundDecoration:
                            BoxDecoration(color: Colors.white),
                        pageController: imagePageController,
                        onPageChanged: onImagePageChanged,
                      ),
                    ),
                    Container(
                      height: 21,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.circle,
                              size: (imagePageIndex == index) ? 15 : 10,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selected[imagePageIndex] = false;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              color: !widget.selected[imagePageIndex]
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            child: Icon(
                              Icons.close,
                              color: !widget.selected[imagePageIndex]
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selected[imagePageIndex] = true;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              color: widget.selected[imagePageIndex]
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            child: Icon(
                              Icons.check,
                              color: widget.selected[imagePageIndex]
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
