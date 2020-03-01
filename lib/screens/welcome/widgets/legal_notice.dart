import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';
import 'package:json_intl/json_intl.dart';

class LegalNotice extends StatelessWidget {
  void onTap(context) {
    BlocProvider.of<LegalBloc>(context).add(LoadLegal());
    showDialog<Widget>(
        context: context,
        builder: (ctx) =>
            BlocBuilder<LegalBloc, LegalState>(builder: (context, state) {
              if (state is LegalLoading) {
                return LoadingIndicator();
              } else if (state is LegalLoaded) {
                return PrivacyPolicy(state.text);
              } else {
                Navigator.pop(context);
                return Container();
              }
            }));
  }

  @override
  Widget build(context) => Container(
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
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: ' ${JsonIntl.of(context).get(IntlKeys.legal3)} ',
            style: finePrint(),
          ),
          TextSpan(
            text: JsonIntl.of(context).get(IntlKeys.legal4),
            style: linkStyle(),
            recognizer: TapGestureRecognizer()..onTap = () => onTap(context),
            semanticsLabel: 'Privacy Policy Button',
          ),
          TextSpan(
            text: ' ${JsonIntl.of(context).get(IntlKeys.legal5)}',
            style: finePrint(),
          ),
        ]),
      )));
}
