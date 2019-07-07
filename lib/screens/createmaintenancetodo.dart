import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:autodo/state.dart';

// class CreateMaintenanceTodoPage extends StatefulWidget {
//   @override
//   CreateMaintenanceTodoPageState createState() =>
//       CreateMaintenanceTodoPageState();
// }

// class CreateMaintenanceTodoPageState extends State<CreateMaintenanceTodoPage> {
//   static const _leftColumnWidth = 16.0; // TODO: check this

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: SafeArea(child: Container(child:
//         ScopedModelDescendant<AutodoState>(builder: (context, child, model) {
//       return Stack(
//         children: <Widget>[
//           ListView(
//             children: [
//               Row(
//                 children: [
//                   SizedBox(
//                     width: _leftColumnWidth,
//                     child: IconButton(
//                       icon: const Icon(Icons.keyboard_arrow_down),
//                       onPressed: () => ExpandingBottomSheet.of(context).close(),
//                     ),
//                   ),
//                   Text('CART EXAMPLE'),
//                   const SizedBox(width: 16.0),
//                   Text('EXAMPLE NUMBER OF ITEMS'),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               Column(
//                 children: [
//                   Text('ENTRY FIELDS HERE'),
//                 ],
//               ),
//               const SizedBox(
//                   height: 100.0), // not sure what this is for exactly
//             ],
//           ),
//           Positioned(
//             bottom: 16.0,
//             left: 16.0,
//             right: 16.0,
//             child: RaisedButton(
//               // Clear cart button
//               child: Text('EXIT BUTTON'),
//               onPressed: () => ExpandingBottomSheet.of(context).close(),
//             ),
//           ),
//         ],
//       );
//     }))));
//   }
// }

class CreateTodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('New Maintenance ToDo'),
      ),
      body: Container(
        child: Card(
          child: Row(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Text('Input 1'),
                    Text('Input 2'),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text('Input 3'),
                    Text('Input 4'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: Icon(Icons.add),
    );
  }
}
