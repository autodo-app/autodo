import 'package:autodo/blocs/cars.dart';
import 'package:autodo/blocs/todo.dart';
import 'package:autodo/theme.dart';
import 'package:flutter/material.dart';
import 'package:autodo/items/items.dart';
import 'package:intl/intl.dart';
import 'package:autodo/screens/screens.dart';
import 'package:autodo/sharedmodels/cartag.dart';

const int DUE_SOON_INTERVAL = 100; 

class MaintenanceTodoCard extends StatefulWidget {
  final MaintenanceTodoItem item;
  final bool emphasized;

  MaintenanceTodoCard({@required this.item, this.emphasized});

  @override
  State<MaintenanceTodoCard> createState() => MaintenanceTodoCardState(emphasized: this.emphasized ?? false);
}

class MaintenanceTodoCardState extends State<MaintenanceTodoCard> {
  bool isChecked = false;
  final bool emphasized;
  MaintenanceTodoCardState({@required this.emphasized});

  Transform checkbox(MaintenanceTodoCard widget) {
    return Transform.scale(
      scale: 1.5,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
        child: Checkbox(
          value: isChecked,
          checkColor: Theme.of(context).primaryColor,
          activeColor: Colors.white,
          onChanged: (bool val) {
            setState(() {
              isChecked = val;
              widget.item.complete = val;
            });
          },
        ),
      ),
    );
  }

  Row dueDate(DateTime date) {
    bool isDate = date != null;
    if (isDate) {
      return Row(
        children: <Widget>[
          Icon(Icons.alarm, size: 30.0),
          Text(
            'Due on ' + DateFormat("MM/dd/yyyy").format(date),
            style: Theme.of(context).primaryTextTheme.body1,
          ),
        ],
      );
    } else {
      return Row();
    }
  }

  Row dueMileage(int mileage) {
    bool isMileage = mileage != null;
    if (isMileage) {
      var mileageString = mileage.toString();
      mileageString = mileageString.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
      return Row(
        children: <Widget>[
          Icon(Icons.pin_drop, size: 30.0),
          Padding(  
            padding: EdgeInsets.all(5),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(  
                  text: 'Due at ',
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
                TextSpan(  
                  text: mileageString,
                  style: Theme.of(context).primaryTextTheme.subtitle,
                ),
                TextSpan(  
                  text: ' miles',
                  style: Theme.of(context).primaryTextTheme.body1,
                )
              ]
            ),
          ),
        ],
      );
    } else {
      return Row();
    }
  }

  Row lastCompleted() {
    // TODO: change this based on past historical data
    return Row(  
      children: <Widget>[
        Icon(Icons.new_releases, size: 30.0),
        Padding(  
          padding: EdgeInsets.all(5),
        ),
        Text(
          'First time doing this task\non this vehicle.',
          style: Theme.of(context).primaryTextTheme.body1,
        ),
      ],
    );
  }

  Container due(MaintenanceTodoCard widget) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          dueDate(widget.item.dueDate),
          Padding( 
            padding: EdgeInsets.all(5),
          ),
          dueMileage(widget.item.dueMileage),
          Padding( 
            padding: EdgeInsets.all(5),
          ),
          lastCompleted(),
        ],
      ),
    );
  }

  Future<String> getNamePreface() async {
    var car = await CarsBLoC().getCarByName(widget.item.tags[0]);
    var distUntilToDo = widget.item.dueMileage - car.mileage;
    if (distUntilToDo < 0)
      return "Past Due: " + widget.item.name;
    else if (distUntilToDo < DUE_SOON_INTERVAL)
      return "Due Soon: " + widget.item.name;
    else 
      return "Upcoming: " + widget.item.name;
  }

  Column title(MaintenanceTodoCard widget) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0, 0.0),
          alignment: Alignment.center,
          child: FutureBuilder(
            future: (emphasized) ? getNamePreface() : null,
            initialData: widget.item.name ?? "", 
            builder: (context, snap) {
              return Text(
                // making sure that the text isn't null.
                // creating a todo without an attached car causes
                // a weird set of behavior upon initial widget creation
                snap.data ?? widget.item.name ?? "",
                style: Theme.of(context).primaryTextTheme.title,
              );
            }
          ),
        ),
        Divider(),
      ],
    );
  }

  Container body(MaintenanceTodoCard widget) {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
      child: Row(
        children: <Widget>[
          checkbox(widget),
          Container(
            height: 100, 
            child: VerticalDivider(
              color: Colors.white.withAlpha(230),
            )
          ),
          due(widget),
        ],
      ),
    );
  }

  Row tags(MaintenanceTodoCard widget) {
    List<Widget> tags = [
      Padding(
        padding: EdgeInsets.only(left: 5.0),
      ),
    ];
    
    for (var tag in widget.item.tags) {
      tags.add(
        FutureBuilder(
          future: CarsBLoC().getCarByName(tag),
          builder: (context, tag) {
            if (tag.data == null) return Container();
            return CarTag(text: tag.data.name, color: tag.data.color);
          }
        )
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: tags,
    );
  }

  Row buttons(MaintenanceTodoCard widget) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
          ),
          child: FlatButton(
            child: Icon(
              Icons.edit,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateTodoScreen(
                          mode: TodoEditMode.EDIT,
                          existing: widget.item,
                        ),
                  ),
                ),
          ),
        ),
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
          ),
          child: FlatButton(
            child: Icon(
              Icons.delete,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onPressed: () {
              TodoBLoC().delete(widget.item);
              final snackbar = SnackBar(
                content: Text('Deleted ' + widget.item.name),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => TodoBLoC().undo(),
                ),
              );
              Scaffold.of(context).showSnackBar(snackbar);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Row footer(MaintenanceTodoCard widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        tags(widget),
        buttons(widget),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var grad1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [mainColors[300], mainColors[400]]
    );
    var grad2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [mainColors[700], mainColors[900]]
    );
    BoxDecoration emphasizedDecoration = BoxDecoration(  
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient.lerp(grad1, grad2, 0.5)
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Card(
        elevation: (emphasized) ? 16.0 : 4.0,
        color: (emphasized) ? Colors.transparent : cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          decoration: (emphasized) ? emphasizedDecoration : BoxDecoration(),
          child: Column(
            children: <Widget>[
              title(widget),
              body(widget),
              footer(widget),
            ],
          ),
        ),
      ),
    );
  }
}
