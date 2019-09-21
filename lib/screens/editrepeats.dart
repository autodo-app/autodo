import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';

class EditRepeatsScreen extends StatefulWidget {
  @override
  EditRepeatsScreenState createState() => EditRepeatsScreenState();
}

class EditRepeatsScreenState extends State<EditRepeatsScreen> {
  final _formKey = GlobalKey<FormState>();
  // List<MapEntry<String, dynamic>> repeatList = [];
  
  // @override
  // void initState() {
  //   var repeats = RepeatingBLoC().orderedRepeats();

  //   // Populate the repeatList with the newest three items
  //   int i = 0;
  //   for (var task in repeats.entries) {
  //     if (i > 2) break;
  //     repeatList.add(task);
  //     i++;
  //   }
  //   super.initState();
  // }

  final Map<String, dynamic> editableRepeats = RepeatingBLoC().orderedRepeats(); // since the values in repeatList are final
  final List mapKeys = List.from(RepeatingBLoC().orderedRepeats().keys);
  List<GlobalKey> formKeys = [];
  GlobalKey createKey() {
    GlobalKey key = GlobalKey<FormState>();
    formKeys.add(key);
    return key;
  }
  FocusNode _node = FocusNode();

  TextFormField repeatNameField(String key) {
    return TextFormField(
      // key: createKey(),
      // focusNode: _node,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        labelText: "ToDo",
        contentPadding: EdgeInsets.only(
            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      initialValue: key,
      autofocus: false,
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {},
      onSaved: (val) => setState(() {
        if (val != null && val != '')
          // Replace the entry for the old key with the new key
          editableRepeats[key] = val;
      }),
    );
  }

  TextFormField repeatValueField(String key) {
    return TextFormField(
      // key: createKey(),
      // focusNode: _node,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        labelText: "Interval",
        contentPadding: EdgeInsets.only(
            left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      initialValue: editableRepeats[key].toString(),
      autofocus: false,
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {},
      onSaved: (val) => setState(() {
        if (val != null && val != '')
          editableRepeats[key] = val;
      }),
    );
  }

  Widget scroller() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mapKeys.length,
        itemBuilder: (BuildContext context, int index) {
          final key = mapKeys[index];
          var divider = (index >= mapKeys.length - 1) ? [] : [Padding(padding: EdgeInsets.all(10)), Divider()];
          return Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(maxHeight: 300),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  repeatNameField(key),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  repeatValueField(key),
                  ...divider,
                ],
              ),
          );
        }
    );
  }

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
        body: scroller(),
      ),
    );
  }
}
