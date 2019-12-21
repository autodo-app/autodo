// import 'package:autodo/blocs/filtering.dart';
// import 'package:autodo/theme.dart';
// import 'package:flutter/material.dart';

// class CarFilters extends StatefulWidget {
//   final callback;
//   CarFilters(this.callback);
//   @override
//   CarFiltersState createState() => CarFiltersState();
// }

// class CarFiltersState extends State<CarFilters> {
//   var filterList;
//   CarFiltersState() {
//     filterList = FilteringBLoC().getFiltersAsList();
//   }

//   Future<void> updateFilters(filter) async {
//     FilteringBLoC().setFilter(filter);
//     widget.callback();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: cardColor,
//       contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//       title: Text('Filter Contents'),
//       content: Container(
//         height: 100,
//         child: ListView.builder(
//           itemCount: FilteringBLoC().getFilters().keys.length,
//           itemBuilder: (context, index) => ListTile(
//               leading: Checkbox(
//                 value: filterList[index].enabled,
//                 onChanged: (state) {
//                   filterList[index].enabled = state;
//                   updateFilters(filterList[index]);
//                   setState(() {});
//                 },
//                 materialTapTargetSize: MaterialTapTargetSize.padded,
//               ),
//               title: Text(filterList[index].carName)),
//         ),
//       ),
//       actions: <Widget>[
//         FlatButton(
//           child: Text(
//             'Done',
//             style: Theme.of(context).primaryTextTheme.button,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ],
//     );
//   }
// }
