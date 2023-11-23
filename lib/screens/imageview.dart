import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final String image;
  const ImageView({super.key, required this.image});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Image.network(widget.image),
      ),
    );
  }
}
