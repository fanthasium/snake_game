import 'package:flutter/material.dart';

class SnakePixel extends StatelessWidget {

  final Color color;
  const SnakePixel({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4)
        ),
      ),
    );
  }
}
