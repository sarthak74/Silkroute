import 'package:flutter/material.dart';

class CustomNetworkImage extends StatefulWidget {
  const CustomNetworkImage({this.url, this.width, this.height});
  final String url;
  final double width, height;

  @override
  _CustomNetworkImageState createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.url,
      height: widget.height,
      width: widget.width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        double value = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
            : null;
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xFF811111),
            value: value,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        return Icon(Icons.error);
      },
    );
  }
}
