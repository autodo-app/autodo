import 'package:about/about.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../generated/localization.dart';
import '../../../theme.dart';

class LegalNotice extends StatelessWidget {
  void _privacyPolicy(context) {
    showMarkdownPage(
      context: context,
      title: Text(JsonIntl.of(context).get(IntlKeys.privacyPolicy)),
      filename: 'legal/privacy-policy.md',
    );
  }

  void _termsAndConditions(context) {}

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Center(
          child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: '${JsonIntl.of(context).get(IntlKeys.legal1)} ',
            style: finePrint(),
          ),
          TextSpan(
            text: JsonIntl.of(context).get(IntlKeys.legal2),
            style: linkStyle(),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _termsAndConditions(context),
          ),
          TextSpan(
            text: ' ${JsonIntl.of(context).get(IntlKeys.legal3)} ',
            style: finePrint(),
          ),
          TextSpan(
            text: JsonIntl.of(context).get(IntlKeys.legal4),
            style: linkStyle(),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _privacyPolicy(context),
            semanticsLabel: 'Privacy Policy Button',
          ),
          TextSpan(
            text: ' ${JsonIntl.of(context).get(IntlKeys.legal5)}',
            style: finePrint(),
          ),
        ]),
      )));
}
