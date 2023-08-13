import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class TekFoto extends StatefulWidget {
  String _url;
  TekFoto(this._url);
  @override
  _TekFotoState createState() => _TekFotoState();
}

class _TekFotoState extends State<TekFoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: PhotoView(
         // enableRotation: true,
          initialScale: PhotoViewComputedScale.contained,
          //maxScale: 0.3,
          //minScale: 0.3,
          imageProvider: NetworkImage(widget._url),
        ),
      ),
    );
  }
}
