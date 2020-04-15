import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../generated/localization.dart';
import 'wizard.dart';
import 'wizard_info.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({@required this.header, @required this.panel});

  final Widget header, panel;

  @override
  AccountSetupScreenState createState() => AccountSetupScreenState();
}

class AccountSetupScreenState extends State<AccountSetupScreen> {
  final Widget pullTab = Container(
    width: 50,
    height: 5,
    decoration: BoxDecoration(
        color: Colors.black.withAlpha(140),
        borderRadius: BorderRadius.all(Radius.circular(12.0))),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Wizard.of<NewUserScreenWizard>(context).previous();
              },
            ),
            expandedHeight: 200,
            title: Text(JsonIntl.of(context).get(IntlKeys.welcome)),
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 110),
              child: widget.header,
            ),
          ),
          SliverToBoxAdapter(child: widget.panel),
        ],
      ),
    );
  }
}
