import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';

class EditRepeatsScreen extends StatefulWidget {
  @override
  EditRepeatsScreenState createState() => EditRepeatsScreenState();
}

class EditRepeatsScreenState extends State<EditRepeatsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Widget scroller() {
  //   return ListView.builder(
  //       padding: const EdgeInsets.all(8),
  //       itemCount: mapKeys.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         final key = mapKeys[index];
  //         var divider = (index >= mapKeys.length - 1) ? [] : [Padding(padding: EdgeInsets.all(10)), Divider()];
  //         return Container(
  //           padding: EdgeInsets.all(10),
  //           constraints: BoxConstraints(maxHeight: 300),
  //           child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Row(
  //                   children: <Widget>[
  //                     Container(
  //                       width: 100,
  //                       padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
  //                       child: Text("Todo Name:", style: TextStyle(fontWeight: FontWeight.bold),),
  //                     ),
  //                     Expanded(
  //                       flex: 7,
  //                       child: repeatNameField(key),
  //                     ),
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.all(10),
  //                 ),
  //                 Row(
  //                   children: <Widget>[
  //                     Container(
  //                       width: 100,
  //                       padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
  //                       child: Text("Interval:"),
  //                     ),
  //                     Expanded(
  //                       flex: 7,
  //                       child: repeatValueField(key),
  //                     ),
  //                     FlatButton(
  //                         onPressed: () {
  //                           Map<String, int> currentRepeat = {key: editableRepeats[key]};
  //                           RepeatingBLoC().delete(currentRepeat);
  //                           final snackbar = SnackBar(
  //                             content: Text('Deleted $key'),
  //                             action: SnackBarAction(
  //                               label: 'Undo',
  //                               onPressed: () => RepeatingBLoC().undo(),
  //                             ),
  //                           );
  //                           Scaffold.of(context).showSnackBar(snackbar);
  //                           setState(() {editableRepeats.remove(key);});
  //                         },
  //                         child: Icon(Icons.delete),
  //                       ),
  //                   ],
  //                 ),
  //                 ...divider,
  //               ],
  //             ),
  //         );
  //       }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomPadding:
            false, // used to avoid overflow when keyboard is viewable
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Edit Repeated Tasks"),
        ),
        body: Container(
          child: RepeatingBLoC().buildList(context),
        ),
      ),
    );
  }
}
