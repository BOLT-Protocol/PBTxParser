import 'package:flutter/material.dart';
import '../utils/i18n.dart';
import '../themes.dart';

final t = I18n.t;

class Footer extends StatelessWidget {
  final Size screenSize;
  Footer({
    this.screenSize,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenSize.height / 4,
      decoration: BoxDecoration(color: PBColors.footer_01),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.1, vertical: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //TODO Icon social media
                Text(
                  t('we_r_social'),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: PBColors.brand_02, fontWeight: FontWeight.w200),
                ),
              ],
            ),
            OutlineButton(
              hoverColor: PBColors.footer_02,
              borderSide: BorderSide(
                color: PBColors.brand_02,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              onPressed: () {
                print('${t('fork_me')}');
              },
              child: Row(
                children: [
                  //TODO Icon github
                  Text(
                    t('fork_me'),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: PBColors.brand_02,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              // alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        t('power_by'),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: PBColors.brand_02,
                              fontWeight: FontWeight.w200,
                            ),
                      ),
                      GestureDetector(
                        child: Text(
                          t('pb_web_services'),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: PBColors.brand_02,
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      t('copyright'),
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: PBColors.brand_02,
                            fontWeight: FontWeight.w200,
                          ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
