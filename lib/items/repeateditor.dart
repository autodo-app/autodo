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
  String valInit = '', nameInit = '';
  bool oneValSaved = false;

  TextFormField repeatNameField() {
    return TextFormField(
      initialValue: nameInit,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      ),
      autofocus: false,
      style: Theme.of(context).primaryTextTheme.subtitle,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      validator: (val) {
        if (val != null && val != '') return null;
        else return "Name must not be empty";
      },
      onSaved: (val) {
        widget.item.name = val;
        // If the other half has saved its value to the widget's item, then
        // push the item to the server
        if (oneValSaved)
          RepeatingBLoC().queueEdit(widget.item);
        else
          oneValSaved = true;
      },
    );
  }

  TextFormField repeatValueField() {
    return TextFormField(
      initialValue: valInit,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        counterText: '', // removes the text showing the number of characters out of max length entered
        contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      ),
      autofocus: false,
      style: Theme.of(context).primaryTextTheme.body1,
      keyboardType: TextInputType.number,
      maxLength: 6,
      validator: (val) {
        int interval;
        try {
          interval = int.parse(val);
        } catch (e) {
          return e;
        }
        if (interval == 0) {  
          return "Interval must not be zero";
        }
        return null;
      },
      onSaved: (val) {
        widget.item.interval = int.parse(val);
        // If the other half has saved its value to the widget's item, then
        // push the item to the server
        if (oneValSaved)
          RepeatingBLoC().queueEdit(widget.item);
        else
          oneValSaved = true;
      },
      onChanged: (val) {
        
      },
    );
  }


  @override 
  Widget build(BuildContext context) {
    // Setting the controller text values here ensures that the textfields
    // actually get updated when another repeat is deleted
    valInit = widget.item.interval.toString();
    nameInit = widget.item.name;
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