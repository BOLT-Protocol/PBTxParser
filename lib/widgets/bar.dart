import 'package:flutter/material.dart';
import 'dart:math' as math show pi;

class Bar extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String title;
  Bar({
    this.screenHeight,
    this.screenWidth,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Row(
        children: [
          Transform.rotate(
              angle: -math.pi / 4,
              child: Icon(
                Icons.send,
                color: Theme.of(context).textTheme.headline1.color,
                size: screenHeight * 0.05,
              )),
          Text(
            title,
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
      width: double.infinity,
      height: 150, //screenHeight * 0.15,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
          begin: const Alignment(0.0, -1.0),
          end: const Alignment(0.0, 0.6),
          colors: <Color>[
            Theme.of(context).accentColor,
            Theme.of(context).textTheme.overline.color,
          ],
        ),
      ),
    );
  }
}
