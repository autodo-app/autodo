import 'dart:math';

import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import 'sliverfooter.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/routes.dart';
import 'upgrade_dialog.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key key}) : super(key: key);

  @override
  State<NavDrawer> createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {
  static const List<Color> userBadgeColors = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.indigo,
    Colors.purple
  ];
  static Random rand = Random();

  Widget userHeader(String username) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: 40.0,
              height: 40.0,
              child: Material(
                elevation: 2.0,
                shape: CircleBorder(),
                color:
                    userBadgeColors[rand.nextInt(userBadgeColors.length - 1)],
                child: Center(
                  child: Text(username[0].toUpperCase()),
                ),
              ),
            ),
          ),
          Text(username),
        ],
      ),
    );
  }

  List<Widget> buttons(bool trialUser) => [
        FlatButton(
          child: Text(
            JsonIntl.of(context).get(IntlKeys.editCarList),
            style: Theme.of(context).primaryTextTheme.button,
          ),
          onPressed: () => Navigator.popAndPushNamed(context, '/editcarlist'),
        ),
        FlatButton(
          key: ValueKey('__settings_drawer_button__'),
          child: Text(
            JsonIntl.of(context).get(IntlKeys.settings),
            style: Theme.of(context).primaryTextTheme.button,
          ),
          onPressed: () =>
              Navigator.popAndPushNamed(context, AutodoRoutes.settingsScreen),
        ),
        FlatButton(
          key: ValueKey('__upgrade_drawer_button__'),
          child: Text(JsonIntl.of(context).get(IntlKeys.upgrade),
              style: Theme.of(context)
                  .primaryTextTheme
                  .button
                  .copyWith(color: Theme.of(context).primaryColor)),
          onPressed: () => showDialog(
              context: context,
              child: UpgradeDialog(
                context: context,
                trialUser: trialUser,
              )),
        )
      ];

  @override
  build(BuildContext context) => BlocBuilder<AuthenticationBloc,
          AuthenticationState>(
      builder: (context, state) => Drawer(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withAlpha(200),
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverFixedExtentList(
                    itemExtent: 140.0,
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return SizedBox.expand(
                        child: DrawerHeader(
                          child: (state is RemoteAuthenticated)
                              ? userHeader(state.displayName)
                              : Container(),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    }, childCount: 1),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 35.0,
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return SizedBox.expand(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: buttons(state is LocalAuthenticated)[index],
                        ),
                      );
                    }, childCount: buttons(state is LocalAuthenticated).length),
                  ),
                  SliverFooter(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FlatButton(
                              key: ValueKey('__sign_out_button__'),
                              child: Text(
                                  JsonIntl.of(context).get(IntlKeys.signOut)),
                              onPressed: () {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(LogOut());
                                Navigator.popAndPushNamed(
                                    context, AutodoRoutes.welcome);
                              },
                            ),
                          ),
                          // TODO: replace this with a flat button too.
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AboutListTile(
                              applicationIcon: Icon(Icons.access_alarm),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
