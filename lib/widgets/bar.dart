import 'package:flutter/material.dart';
import 'dart:math' as math show pi;

class Bar extends StatelessWidget {
  final Size screenSize;
  final String title;
  Bar({
    this.screenSize,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.width > 414
              ? screenSize.width * 0.1
              : screenSize.width * 0.05),
      child: Row(
        children: [
          Transform.rotate(
              angle: -math.pi / 4,
              child: Icon(
                Icons.send,
                color: Theme.of(context).textTheme.headline1.color,
                size: screenSize.height * 0.05,
              )),
          Text(
            title,
            style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: screenSize.width > 585
                    ? Theme.of(context).textTheme.headline1.fontSize
                    : screenSize.width > 414
                        ? Theme.of(context).textTheme.headline2.fontSize
                        : Theme.of(context).textTheme.headline4.fontSize),
            overflow: TextOverflow.fade,
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
