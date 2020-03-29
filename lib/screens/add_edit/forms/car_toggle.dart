import 'package:flutter/material.dart';
import '../../../models/models.dart';

class CarToggleForm extends StatefulWidget {
  const CarToggleForm(this.initialState, this.cars, this.onSaved);

  final List<bool> initialState;

  final List<Car> cars;

  final Function onSaved;

  @override
  CarToggleFormState createState() =>
      CarToggleFormState(initialState, cars, onSaved);
}

class CarToggleFormState extends State<CarToggleForm> {
  CarToggleFormState(this.isSelected, this.cars, this.onSaved);

  List<bool> isSelected;

  final List<Car> cars;

  final Function onSaved;

  @override
  Widget build(context) => FormField(
        builder: (state) => Center(
          child: ToggleButtons(
            children: cars.map((c) => Text(c.name)).toList(),
            onPressed: (int index) {
              setState(() {
                for (var buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: isSelected,
            // Constraints are per the Material spec
            constraints: BoxConstraints(minWidth: 88, minHeight: 36),
            textStyle: Theme.of(context).primaryTextTheme.button,
            color: Theme.of(context)
                .primaryTextTheme
                .button
                .color
                .withOpacity(0.7),
            selectedColor: Theme.of(context).accentTextTheme.button.color,
            fillColor: Theme.of(context).primaryColor,
            borderWidth: 2.0,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onSaved: (_) => onSaved(isSelected),
        validator: (_) => null,
      );
}
