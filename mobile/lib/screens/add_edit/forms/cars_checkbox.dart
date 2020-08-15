import 'package:flutter/material.dart';

import '../../../models/models.dart';

class CarsCheckboxForm extends StatefulWidget {
  const CarsCheckboxForm({this.cars, this.onSaved});

  final List<Car> cars;

  final Function(List<Map<String, dynamic>>) onSaved;

  @override
  _CarsFormState createState() => _CarsFormState(cars, onSaved);
}

class _CarsFormState extends State<CarsCheckboxForm> {
  _CarsFormState(this.cars, this.onSaved) {
    for (var car in cars) {
      _carStates.add({'name': car.name, 'enabled': false});
    }
  }

  final List<Car> cars;

  final Function(List<Map<String, dynamic>>) onSaved;

  final List<Map<String, dynamic>> _carStates = [];

  @override
  Widget build(BuildContext context) => FormField<List<Map<String, dynamic>>>(
        builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                cars.length,
                (index) => ListTile(
                    leading: Checkbox(
                      key: ValueKey(
                          '__car_checkbox_${_carStates[index]['name']}'),
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
