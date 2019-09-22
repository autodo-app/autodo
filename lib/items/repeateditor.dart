import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/items/repeat.dart';

class RepeatEditor extends StatefulWidget {
  final Repeat item;
  RepeatEditor({@required this.item}) {
    if (this.item.name == '') this.item.name = 'New Repeat';
  }

  @override 
  State<StatefulWidget> createState() => RepeatEditorState();
}

class RepeatEditorState extends State<RepeatEditor> {
  final _nameCtrl = TextEditingController();
  final _valCtrl = TextEditingController();

  @override
  void initState() {
    _nameCtrl.text = widget.item.name;
    _valCtrl.text = widget.item.interval.toString();
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valCtrl.dispose();
    super.dispose();
  }

  TextFormField repeatNameField() {
    return TextFormField(
      controller: _nameCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      ),
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
          widget.item.name = val;
      }),
    );
  }

  TextFormField repeatValueField() {
    return TextFormField(
      // key: createKey(),
      controller: _valCtrl,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        counterText: '', // removes the text showing the number of characters out of max length entered
        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      ),
      autofocus: false,
      style: TextStyle(
        fontSize: 22.0,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 6,
      validator: (value) {},
      onSaved: (val) => setState(() {
        if (val != null && val != '')
          widget.item.interval = int.parse(val);
      }),
    );
  }


  @override 
  Widget build(BuildContext context) {
    // Setting the controller text values here ensures that the textfields
    // actually get updated when another repeat is deleted
    _nameCtrl.text = widget.item.name;
    _valCtrl.text = widget.item.interval.toString();
    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 300),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                  child: Text("Todo Name:", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  flex: 7,
                  child: repeatNameField(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                  child: Text("Interval:"),
                ),
                Expanded(
                  flex: 7,
                  child: repeatValueField(),
                ),
                FlatButton(
                    onPressed: () {
                      print("deleting ${widget.item.name}");
                      RepeatingBLoC().delete(widget.item);
                      final snackbar = SnackBar(
                        content: Text('Deleted ${widget.item.name}'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () => RepeatingBLoC().undo(),
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackbar);
                    },
                    child: Icon(Icons.delete),
                  ),
              ],
            ),
          ],
        ),
    );
  }
}