import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../theme.dart';
import '../../../util.dart';

class CarForm extends StatefulWidget {
  const CarForm({
    Key key,
    this.initialValue,
    @required this.onSaved,
    @required this.node,
    @required this.nextNode,
  }) : super(key: key);

  final String initialValue;

  final Function(String) onSaved;

  final FocusNode node, nextNode;

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
  void initState() {
    _autocompleteController = TextEditingController();
    _autocompleteController.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _autocompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_autocompleteController.text);
    // pulled out into the function so that the validator can access it
    autoCompleteField = AutoCompleteTextField<Car>(
      controller: _autocompleteController,
      decoration: defaultInputDecoration(
        context,
        JsonIntl.of(context).get(IntlKeys.carName),
        rule: InputRule.required,
      ).copyWith(errorText: _carError),
      itemSubmitted: (item) => setState(() {
        _autocompleteController.text = item.name;
        selectedCar = item;
      }),
      key: _autocompleteKey,
      focusNode: widget.node,
      textInputAction: TextInputAction.next,
      suggestions:
          (BlocProvider.of<DataBloc>(context).state as DataLoaded).cars,
      itemBuilder: (context, suggestion) => Padding(
        child: ListTile(
            title: Text(suggestion.name),
            trailing: Text(
              // Todo: Improve this translation
              '${JsonIntl.of(context).get(IntlKeys.mileage)}: ${suggestion.odomSnapshot.mileage}',
            )),
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
            context,
            JsonIntl.of(context).get(IntlKeys.carName),
            rule: InputRule.required,
          ).copyWith(errorText: res),
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
