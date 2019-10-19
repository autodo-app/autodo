import 'package:flutter/material.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/theme.dart';

class PrivacyPolicy {
  static Future<String> loadAsset(context) async {
    return await DefaultAssetBundle.of(context).loadString('legal/privacy-policy.md');
  }

  static RichText txt;

  static void init(BuildContext context) async {
    var text = await loadAsset(context);
    txt = RichText(
      text: MarkdownParser.parse(text)
    );
  }
  
  static Widget text() {
    return txt;
  }

  static Widget dialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: cardColor,
      title: Text('Privacy Policy'),
      titleTextStyle: Theme.of(context).primaryTextTheme.title,
      content: SingleChildScrollView(  
        child: Container(  
          child: PrivacyPolicy.text()    
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      actions: <Widget>[ 
        FlatButton(
          child: Text(
            'Got it!',
            style: Theme.of(context).primaryTextTheme.button,
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}