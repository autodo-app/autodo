import 'package:flutter/material.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/items/repeat.dart';

class RepeatEditor extends StatefulWidget {
  final Repeat item;
  RepeatEditor({@required this.item});

  @override 
  State<StatefulWidget> createState() => RepeatEditorState();
}

class RepeatEditorState extends State<RepeatEditor> {
  TextFormField repeatNameField(String key) {
    return TextFormField(
      // key: createKey(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 5),
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
          widget.item.name = val;
      }),
    );
  }

  TextFormField repeatValueField(String key) {
    return TextFormField(
      // key: createKey(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        counterText: '', // removes the text showing the number of characters out of max length entered
        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      ),
      initialValue: widget.item.interval.toString(),
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
                  child: repeatNameField(widget.item.name),
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
                  child: repeatValueField(widget.item.name),
                ),
                FlatButton(
                    onPressed: () {
                      RepeatingBLoC().delete(widget.item);
                      final snackbar = SnackBar(
                        content: Text('Deleted $widget.item.name'),
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