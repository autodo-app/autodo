import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../generated/localization.dart';
import '../../generated/pubspec.dart';

Future<void> about(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AboutPage(
          applicationName: JsonIntl.of(context).get(IntlKeys.appTitle),
          applicationLegalese:
              'Copyright © {{ appName }}, {{ year }}\n{{ authors }}.',
          applicationVersion: JsonIntl.of(context)
              .get(IntlKeys.version, {'version': Pubspec.versionSmall}),
          applicationDescription:
              Text(JsonIntl.of(context).get(IntlKeys.welcomeDesc)),
          children: <Widget>[
            MarkdownPageListTile(
              icon: Icon(Icons.list),
              title: const Text('Privacy Policy'),
              filename: 'legal/privacy-policy.md',
            ),
            LicensesPageListTile(
              icon: Icon(Icons.favorite),
            ),
          ],
          applicationIcon: const SizedBox(
            width: 100,
            height: 100,
            child: Image(
              image: AssetImage('img/icon.png'),
            ),
          ),
          values: {
            'authors': Pubspec.authorsName.join(',\n'),
            'appName': JsonIntl.of(context).get(IntlKeys.appTitle),
          });
    },
  );
}
