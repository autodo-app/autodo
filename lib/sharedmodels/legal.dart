import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  Future<String> loadAsset(context) async {
    return await DefaultAssetBundle.of(context).loadString('legal/privacy-policy.md');
  }

  @override 
  Widget build(BuildContext context) {
    loadAsset(context);
    return Text('hs');
  }
}