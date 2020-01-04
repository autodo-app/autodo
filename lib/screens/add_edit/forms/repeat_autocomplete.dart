import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';

class RepeatForm extends StatefulWidget {
  final Todo todo;
  final Function(String) onSaved;
  final FocusNode node, nextNode;
  final bool requireInput;

  RepeatForm({
    Key key,
    this.todo,
    @required this.onSaved,
    @required this.node,
    this.nextNode,
    @required this.requireInput,
  }) : super(key: key);

  @override
  _RepeatFormState createState() => _RepeatFormState();
}

class _RepeatFormState extends State<RepeatForm> {
  AutoCompleteTextField<Repeat> autoCompleteField;
  TextEditingController _autocompleteController;
  Repeat selectedRepeat;
  String _repeatError;
  final _autocompleteKey = GlobalKey<AutoCompleteTextFieldState<Repeat>>();
  List<Repeat> repeats;

  @override
  initState() {
    _autocompleteController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    _autocompleteController.dispose();
    super.dispose();
  }

  @override
  build(context) {
    autoCompleteField = AutoCompleteTextField<Repeat>(
      controller: _autocompleteController,
      decoration: defaultInputDecoration(AutodoLocalizations.requiredLiteral,
              AutodoLocalizations.repeatName)
          .copyWith(errorText: _repeatError),
      itemSubmitted: (item) => setState(() {
        _autocompleteController.text = item.name;
        selectedRepeat = item;
      }),
      key: _autocompleteKey,
      focusNode: widget.node,
      textInputAction: TextInputAction.done,
      suggestions: repeats,
      itemBuilder: (context, suggestion) => Padding(
        child: ListTile(
            title: Text(suggestion.name),
            trailing: Text(AutodoLocalizations.interval +
                ": ${suggestion.mileageInterval}")),
        padding: EdgeInsets.all(5.0),
      ),
      itemSorter: (a, b) => a.name.length == b.name.length
          ? 0
          : a.name.length < b.name.length ? -1 : 1,
      // returns a match anytime that the input is anywhere in the repeat name
      itemFilter: (suggestion, input) {
        return suggestion.name.toLowerCase().contains(input.toLowerCase());
      },
      textSubmitted: (_) {},
    );
    return FormField<String>(
      builder: (FormFieldState<String> input) => autoCompleteField,
      initialValue: widget.todo?.repeatName ?? '',
      validator: (val) {
        var txt = _autocompleteController.text;
        if (widget.requireInput) {
          var res = requiredValidator(txt);
          // TODO figure this out better
          // if (selectedCar != null)
          //   widget.refueling.carName = selectedCar.name;
          // else if (val != null && cars.any((element) => element.name == val)) {
          //   widget.refueling.carName = val;
          // }
          autoCompleteField.updateDecoration(
            decoration: defaultInputDecoration(
                    AutodoLocalizations.requiredLiteral,
                    AutodoLocalizations.carName)
                .copyWith(errorText: res),
          );
          setState(() => _repeatError = res);
          return _repeatError;
        } else {
          return null;
        }
      },
      onSaved: (val) => widget.onSaved(val),
    );
  }
}
