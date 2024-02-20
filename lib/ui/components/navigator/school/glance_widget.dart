import 'package:flutter/material.dart';

class SchoolGlance extends StatelessWidget {
  final ImageProvider<Object> image;
  const SchoolGlance(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Image(
        image: image,
        height: 100,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain,
      ),
    );
  }
}
