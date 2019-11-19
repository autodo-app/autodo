import 'package:autodo/blocs/cars.dart';
import 'package:autodo/sharedmodels/cartag.dart';
import 'package:flutter/material.dart';
import 'package:autodo/items/items.dart';
import 'package:intl/intl.dart';
import 'package:autodo/screens/screens.dart';
import 'package:autodo/blocs/refueling.dart';

class RefuelingCard extends StatefulWidget {
  final RefuelingItem item;

  RefuelingCard({
    @required this.item,
  });

  @override
  State<RefuelingCard> createState() {
    return RefuelingCardState();
  }
}

class RefuelingCardState extends State<RefuelingCard> {
  bool expanded = false;

  Widget checkbox(RefuelingCard widget) {
    return Row();
  }

  List<Widget> additionalStats() {
    Color textColor = Theme.of(context).iconTheme.color.withAlpha(200);

    if (expanded) {
      return [
        Row(
          children: <Widget>[
            Text(
              'Fuel Efficiency: ',
              style: TextStyle(
                color: textColor,
              ),
            ),
            Text(
              (widget.item.efficiency == double.infinity) ? "N/A" : widget.item.efficiency.toStringAsFixed(3),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            Text(
              (widget.item.efficiency == double.infinity) ? "" : ' mpg',
              style: TextStyle(
                color: textColor,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              'Cost per ' + 'gal: ',
              style: TextStyle(
                color: textColor,
              ),
            ),
            Text(
              widget.item.costpergal.toStringAsFixed(3),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            Text(
              ' USD/gal',
              style: TextStyle(
                color: textColor,
              ),
            ),
          ],
        ),
      ];
    } else {
      return [];
    }
  }

  Container stats(RefuelingCard widget) {
    Color textColor = Theme.of(context).iconTheme.color.withAlpha(200);

    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total Cost: ',
                style: TextStyle(
                  color: textColor,
                ),
              ),
              Text(
                '\$' + widget.item.cost.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Total Amount: ',
                style: TextStyle(
                  color: textColor,
                ),
              ),
              Text(
                widget.item.amount.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              Text(
                ' gal',
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ],
          ),
          ...additionalStats(),
        ],
      ),
    );
  }

  Column title(RefuelingCard widget) {
    DateTime date = widget.item.date;
    String dateStr =
        date != null ? ' on ' + DateFormat("MM/dd/yyyy").format(date) : '';
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 0.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Text(
                'Refueling' + dateStr + ' at ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: dateStr == '' ? 18.0 : 16.0,
                ),
              ),
              Text(
                widget.item.odom.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: dateStr == '' ? 20.0 : 18.0,
                ),
              ),
              Text(
                ' miles',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: dateStr == '' ? 18.0 : 16.0,
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Container body(RefuelingCard widget) {
    return Container(
      child: Row(
        children: <Widget>[
          checkbox(widget),
          stats(widget),
        ],
      ),
    );
  }

  Widget tags(RefuelingCard widget) {
    return FutureBuilder( 
      future: CarsBLoC().getCarByName(widget.item.carName),
      builder: (context, tag) {
        if (tag.data == null) return Container();
        return CarTag(text: tag.data.name, color: tag.data.color);
      } 
    );
  }

  Row buttons(RefuelingCard widget) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonTheme.fromButtonThemeData(
          data: ButtonThemeData(
            minWidth: 0,
          ),
          child: FlatButton(
            child: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateRefuelingScreen(
                          mode: RefuelingEditMode.EDIT,
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
            child: const Icon(Icons.delete),
            onPressed: () {
              RefuelingBLoC().delete(widget.item);
              final snackbar = SnackBar(
                content: Text('Deleted Refueling.'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => RefuelingBLoC().undo(),
                ),
              );
              Scaffold.of(context).showSnackBar(snackbar);
            },
          ),
        ),
      ],
    );
  }

  Row footer(RefuelingCard widget) {
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
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: InkWell(
        onTap: () => setState(() => expanded = !expanded),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            child: Column(
              children: <Widget>[
                title(widget),
                body(widget),
                footer(widget),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
