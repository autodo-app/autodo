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

  Widget name() {
    return Align(
      alignment: Alignment.centerLeft, 
      child: RichText(  
        textAlign: TextAlign.left,
        text: TextSpan(  
          children: [ 
            TextSpan(  
              text: 'Task Name:  ',
              style: Theme.of(context).primaryTextTheme.subtitle
            ),
            TextSpan(
              text: nameInit,
              style: Theme.of(context).primaryTextTheme.subtitle
                .copyWith(fontWeight: FontWeight.w600)
            ),
          ]
        )
      )
    );
  }

  Widget value() {
    return Align(
      alignment: Alignment.centerLeft, 
      child: RichText(  
        textAlign: TextAlign.left,
        text: TextSpan(  
          children: [ 
            TextSpan(  
              text: 'Interval:  ',
              style: Theme.of(context).primaryTextTheme.body1
            ),
            TextSpan(
              text: valInit,
              style: Theme.of(context).primaryTextTheme.body1
                .copyWith(fontWeight: FontWeight.w600)
            ),
          ]
        )
      )
    );
  }

  @override 
  Widget build(BuildContext context) {
    // Setting the controller text values here ensures that the textfields
    // actually get updated when another repeat is deleted
    valInit = widget.item.interval.toString();
    nameInit = widget.item.name;
    return Container(
      padding: EdgeInsets.all(15),
      constraints: BoxConstraints(maxHeight: 300),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            name(),
            Flex( 
              direction: Axis.horizontal,
              children: <Widget>[ 
                Expanded( 
                  flex: 7,
                  child: value(),
                ),
                Expanded( 
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row( 
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(  
                          onPressed: () {},
                          icon: Icon(Icons.edit)
                        ),
                        IconButton(
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
                          icon: Icon(Icons.delete),
                        ),
                      ]
                    )
                  )
                )
              ],
            )
            // Row(
            //   children: <Widget>[
            //     Container(
            //       width: 80,
            //       padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
            //       child: Text("Interval:"),
            //     ),
            //     Expanded(
            //       flex: 7,
            //       child: repeatValueField(),
            //     ),
            //     FlatButton(
            //         onPressed: () {
            //           RepeatingBLoC().delete(widget.item);
            //           final snackbar = SnackBar(
            //             content: Text('Deleted ${widget.item.name}'),
            //             action: SnackBarAction(
            //               label: 'Undo',
            //               onPressed: () => RepeatingBLoC().undo(),
            //             ),
            //           );
            //           Scaffold.of(context).showSnackBar(snackbar);
            //         },
            //         child: Icon(Icons.delete),
            //       ),
            //   ],
            // ),
          ],
        ),
    );
  }
}