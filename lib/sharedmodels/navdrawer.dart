import 'package:flutter/material.dart';
import 'package:autodo/sharedmodels/sliverfooter.dart';
import 'package:autodo/blocs/userauth.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [
      FlatButton(
        child: Text('Refueling History'),
        onPressed: () => Navigator.pushNamed(context, '/refuelinghistory'),
      ),
      FlatButton(
        child: Text('Statistics'),
        onPressed: () {},
      ),
      Divider(),
      FlatButton(
        child: Text('Edit Car List'),
        onPressed: () {},
      ),
      FlatButton(
        child: Text('Settings'),
        onPressed: () => Navigator.pushNamed(context, '/settings'),
      ),
    ];

    return Drawer(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverFixedExtentList(
            itemExtent: 200.0,
            delegate: SliverChildBuilderDelegate((context, index) {
              return SizedBox.expand(
                child: DrawerHeader(
                  child: Text('User information here?'),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }, childCount: 1),
          ),
          SliverFixedExtentList(
            itemExtent: 40.0,
            delegate: SliverChildBuilderDelegate((context, index) {
              return SizedBox.expand(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: buttons[index],
                ),
              );
            }, childCount: buttons.length),
          ),
          SliverFooter(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                      child: Text('Sign Out'),
                      onPressed: () {
                        Auth userAuth = Auth();
                        userAuth.signOut();
                        Navigator.pushNamed(context, '/welcomepage');
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
      // child: ListView(
      //   padding: EdgeInsets.zero,
      //   children: <Widget>[
      //     DrawerHeader(
      //       child: Text('Drawer Header'),
      //       decoration: BoxDecoration(
      //         color: Theme.of(context).primaryColor,
      //       ),
      //     ),
      //     ListTile(
      //       title: Text('Item 1'),
      //       onTap: () {
      //         Navigator.pop(
      //             context); // This causes the drawer to go away when an item is clicked
      //       },
      //     ),
    );
  }
}
