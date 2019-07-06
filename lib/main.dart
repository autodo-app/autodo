import 'package:flutter/material.dart';
import 'package:autodo/app.dart';

void main() => runApp(VanillaApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
//         fontFamily: 'Montserrat',
//       ),
//       home: MaintenancePage(),
//     );
//   }
// }

// class MaintenanceToDo extends StatefulWidget {
//   @override
//   createState() => new MaintenanceToDoState();
// }

// class MaintenanceItem {
//   String name;
//   DateTime dueDate;
//   int dueMileage;

//   MaintenanceItem(this.name, this.dueDate, this.dueMileage);
// }

// class MaintenanceToDoState extends State<MaintenanceToDo> {
//   static List<MaintenanceItem> _items = [
//     MaintenanceItem("Test", DateTime(2019, 1, 1), 10000),
//     MaintenanceItem("Test 2", DateTime(2019, 1, 1), 10000),
//   ];

//   void addItem() {
//     setState(() =>
//         _items.add(MaintenanceItem("Test 2", DateTime(2019, 1, 1), 10000)));
//   }

//   ListTile makeListTile(MaintenanceItem item) {
//     return ListTile(
//       title: Text(item.name),
//       subtitle: Row(
//         children: <Widget>[
//           Icon(Icons.alarm),
//           Text('  ' + item.dueDate.toString()),
//         ],
//       ),
//     );
//   }

//   Card makeCard(MaintenanceItem item) {
//     return Card(
//       elevation: 8.0,
//       margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//       child: Container(
//         decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
//         child: makeListTile(item),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         itemCount: 10,
//         itemBuilder: (BuildContext context, int index) {
//           if (index < _items.length) {
//             return makeCard(_items[index]);
//           }
//         },
//       ),
//     );
//   }
// }
