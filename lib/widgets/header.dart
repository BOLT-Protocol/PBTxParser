import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Size screenSize;
  final double scrollPosition;
  final String title;
  Header({
    this.screenSize,
    this.scrollPosition,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    // height: 80
    return GestureDetector(
      onTap: () {
        // TODO REFRESH
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.1, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/ic_launcher.png',
                  width: 50,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      color: Theme.of(context).textTheme.headline3.color),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'ScrollPosition: $scrollPosition',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Theme.of(context).textTheme.headline3.color),
                ),
                SizedBox(width: 10),
                Text(
                  'Height: ${screenSize.height}',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Theme.of(context).textTheme.headline3.color),
                ),
                SizedBox(width: 10),
                Text(
                  'Width: ${screenSize.width}',
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Theme.of(context).textTheme.headline3.color),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
