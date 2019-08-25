import 'package:autodo/blocs/userauth.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.pop(
                  context); // This causes the drawer to go away when an item is clicked
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              Auth userAuth = Auth();
              userAuth.signOut();
              Navigator.pushNamed(context, '/welcomepage');
            },
          ),
        ],
      ),
    );
  }
}
