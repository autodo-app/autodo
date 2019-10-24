import 'package:autodo/refueling/history.dart';
import 'package:autodo/screens/editrepeats.dart';
import 'package:autodo/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:autodo/sharedmodels/sharedmodels.dart';
import 'package:autodo/maintenance/history.dart';
import 'package:autodo/theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

enum dropdown { settings }

class HomeScreenState extends State<HomeScreen> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> bodies = [
      MaintenanceHistory(),
      RefuelingHistory(),
      StatisticsScreen(),
      EditRepeatsScreen(),
    ];

    IndexedStack bodyStack = IndexedStack(  
      index: tabIndex,
      children: bodies,
    );
    
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
                if (res == dropdown.settings) {
                  Navigator.pushNamed(context, '/settings');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<dropdown>>[
                    const PopupMenuItem<dropdown>(
                      value: dropdown.settings,
                      child: Text('Settings'),
                    ),
                  ],
            ),
          ],
        ),
        // body: MaintenanceHistory(),
        // body: bodies[tabIndex],
        body: bodyStack,
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
