import 'dart:async';

import 'package:autodo/refueling/history.dart';
import 'package:autodo/screens/editrepeats.dart';
import 'package:autodo/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:autodo/sharedmodels/sharedmodels.dart';
import 'package:autodo/maintenance/history.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

enum dropdown { filter }

class HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;
  StreamSubscription authStream;
  bool signedIn = false;

  void onAuthChange(FirebaseUser user) {
    if (user!= null && user.uid != null) {
      setState(() {
        signedIn = true;
      });
    } else {
      setState(() {
        signedIn = false;
      });
    }
  }

  HomeScreenState() {
    authStream = Auth().listen(onAuthChange);
  }

  @override 
  void dispose() {
    authStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IndexedStack bodyStack;

    if (signedIn) {
      List<Widget> bodies = [
        MaintenanceHistory(),
        RefuelingHistory(),
        StatisticsScreen(),
        EditRepeatsScreen(),
      ];

      bodyStack = IndexedStack(  
        index: tabIndex,
        children: bodies,
      );
    }
    
    return Container(
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'auToDo',
              style: logoStyle,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<dropdown>(
              icon: Icon(Icons.more_vert),
              onSelected: (dropdown res) {
                if (res == dropdown.filter) {
                  showDialog(
                    context: context,
                    builder: (context) => CarFilters(() => setState(() {})),
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<dropdown>>[
                const PopupMenuItem<dropdown>(
                  value: dropdown.filter,
                  child: Text('filter'),
                ),
              ],
            ),
          ],
        ),
        body: (signedIn) ? bodyStack : Container(),
        bottomNavigationBar: BottomNavigationBar(  
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: (index) => setState(() => tabIndex = index),
          currentIndex: tabIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              title: Text('ToDos')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_gas_station),
              title: Text('Refuelings')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              title: Text('Statistics')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              title: Text('Repeats')
            ),
          ]
        ),
        drawer: NavDrawer(),
        floatingActionButton: CreateEntryButton(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
