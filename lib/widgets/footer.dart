import 'package:flutter/material.dart';
import '../utils/i18n.dart';
import '../themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final t = I18n.t;

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

class Footer extends StatelessWidget {
  final Size screenSize;
  Footer({
    this.screenSize,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenSize.width > 900
          ? screenSize.height / 4
          : screenSize.height / 2.5,
      decoration: BoxDecoration(color: PBColors.footer_01),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.1, vertical: 32),
        child: Flex(
          direction: screenSize.width > 900 ? Axis.horizontal : Axis.vertical,
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
                IconButton(
                    icon: FaIcon(FontAwesomeIcons.facebook),
                    onPressed: () => _launchInBrowser(
                        'https://www.facebook.com/groups/2545286695753569/'),
                    color: PBColors.brand_02)
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
                _launchInBrowser('https://github.com/BOLT-Protocol/PBTxParser');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //TODO Icon github
                  Text(
                    t('fork_me'),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: PBColors.brand_02,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  FaIcon(
                    FontAwesomeIcons.github,
                    color: PBColors.brand_02,
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
