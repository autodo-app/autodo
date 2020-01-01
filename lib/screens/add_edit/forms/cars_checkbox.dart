import 'package:flutter/material.dart';

import 'package:autodo/models/models.dart';

class CarsCheckboxForm extends StatefulWidget {
  final List<Car> cars;
  final Function(List<Map<String, dynamic>>) onSaved;

  CarsCheckboxForm({this.cars, this.onSaved});

  @override
  _CarsFormState createState() => _CarsFormState(cars, onSaved);
}

class _CarsFormState extends State<CarsCheckboxForm> {
  final List<Car> cars;
  final Function(List<Map<String, dynamic>>) onSaved;
  List<Map<String, dynamic>> _carStates = [];

  _CarsFormState(this.cars, this.onSaved) {
    for (var car in cars) {
      _carStates.add({'name': car.name, 'enabled': false});
    }
  }

  @override
  build(context) => FormField<List<Map<String, dynamic>>>(
        builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                cars.length,
                (index) => ListTile(
                    leading: Checkbox(
                      key: ValueKey('__car_checkbox_${_carStates[index]['name']}'),
                      value: _carStates[index]['enabled'],
                      onChanged: (state) {
                        _carStates[index]['enabled'] = state;
                        setState(() {});
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    title: Text(_carStates[index]['name'])))),
        onSaved: (_) => onSaved(_carStates),
      );
}
