import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';
import 'package:json_intl/json_intl.dart';

class CarForm extends StatefulWidget {
  final String initialValue;
  final Function(String) onSaved;
  final FocusNode node, nextNode;

  CarForm({
    Key key,
    this.initialValue,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key) {
    print(initialValue);
  }

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  AutoCompleteTextField<Car> autoCompleteField;
  TextEditingController _autocompleteController;
  Car selectedCar;
  String _carError;
  final _autocompleteKey = GlobalKey<AutoCompleteTextFieldState<Car>>();
  List<Car> cars;

  @override
  initState() {
    _autocompleteController = TextEditingController();
    _autocompleteController.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  dispose() {
    _autocompleteController.dispose();
    super.dispose();
  }

  @override
  build(context) {
    print(_autocompleteController.text);
    // pulled out into the function so that the validator can access it
    autoCompleteField = AutoCompleteTextField<Car>(
      controller: _autocompleteController,
      decoration: defaultInputDecoration(
              JsonIntl.of(context).get(IntlKeys.requiredLiteral),
              JsonIntl.of(context).get(IntlKeys.carName))
          .copyWith(errorText: _carError),
      itemSubmitted: (item) => setState(() {
        _autocompleteController.text = item.name;
        selectedCar = item;
      }),
      key: _autocompleteKey,
      focusNode: widget.node,
      textInputAction: TextInputAction.next,
      suggestions:
          (BlocProvider.of<CarsBloc>(context).state as CarsLoaded).cars,
      itemBuilder: (context, suggestion) => Padding(
        child: ListTile(
            title: Text(suggestion.name),
            trailing: Text(JsonIntl.of(context).get(IntlKeys.mileage) +
                ": ${suggestion.mileage}")),
        padding: EdgeInsets.all(5.0),
      ),
      itemSorter: (a, b) => a.name.length == b.name.length
          ? 0
          : a.name.length < b.name.length ? -1 : 1,
      // returns a match anytime that the input is anywhere in the repeat name
      itemFilter: (suggestion, input) {
        return suggestion.name.toLowerCase().contains(input.toLowerCase());
      },
      textSubmitted: (_) => changeFocus(widget.node, widget.nextNode),
    );
    return FormField<String>(
      initialValue: widget.initialValue,
      builder: (FormFieldState<String> input) {
        // workaround for the fact that the text is cleared on rebuild?
        _autocompleteController.text = selectedCar?.name ?? '';
        return autoCompleteField;
      },
      validator: (val) {
        final txt = _autocompleteController.text;
        final res = requiredValidator(txt);
        autoCompleteField.updateDecoration(
          decoration: defaultInputDecoration(
                  JsonIntl.of(context).get(IntlKeys.requiredLiteral),
                  JsonIntl.of(context).get(IntlKeys.carName))
              .copyWith(errorText: res),
        );
        setState(() => _carError = res);
        return _carError;
      },
      onSaved: (val) {
        widget.onSaved(_autocompleteController.text);
      },
    );
  }
}
