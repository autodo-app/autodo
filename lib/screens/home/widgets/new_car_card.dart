import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class NewCarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {}, // TODO: push the car add/edit screen here
    child: Container(
      width: 140,
      height: 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Center(
        // This centering and its child are needed to prevent the edge of the
        // border from being cut off past 1px
        child: SizedBox(
          width: 130, // smae goes for the sizes here, need to undersize the child to account for the border
          height: 205,
          child: DottedBorder(
            color: Theme.of(context).buttonTheme.colorScheme.background,
            padding: EdgeInsets.all(5),
            strokeWidth: 4,
            dashPattern: [15, 15],
            borderType: BorderType.RRect,
            radius: Radius.circular(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, size: 48, color: Theme.of(context).buttonTheme.colorScheme.background,),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Add a New Car',
                      style: Theme.of(context).primaryTextTheme.subtitle2
                          .copyWith(color: Theme.of(context).buttonTheme.colorScheme.background),
                      textAlign: TextAlign.center,
                    )
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    )
  );
}