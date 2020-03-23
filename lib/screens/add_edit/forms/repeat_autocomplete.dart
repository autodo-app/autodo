import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/generated/localization.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';
import 'package:json_intl/json_intl.dart';

class RepeatForm extends StatefulWidget {
  const RepeatForm({
    Key key,
    this.todo,
    @required this.onSaved,
    @required this.node,
    this.nextNode,
    @required this.requireInput,
  }) : super(key: key);

  final Todo todo;

  final Function(String) onSaved;

  final FocusNode node, nextNode;

  final bool requireInput;

  @override
  _RepeatFormState createState() => _RepeatFormState();
}

class _RepeatFormState extends State<RepeatForm> {
  AutoCompleteTextField<Repeat> autoCompleteField;
  TextEditingController _autocompleteController;
  Repeat selectedRepeat;
  String _repeatError;
  final _autocompleteKey = GlobalKey<AutoCompleteTextFieldState<Repeat>>();

  @override
  void initState() {
    _autocompleteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _autocompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    autoCompleteField = AutoCompleteTextField<Repeat>(
      controller: _autocompleteController,
      decoration: defaultInputDecoration(
              JsonIntl.of(context).get(IntlKeys.requiredLiteral),
              JsonIntl.of(context).get(IntlKeys.repeatName))
          .copyWith(errorText: _repeatError),
      itemSubmitted: (item) => setState(() {
        _autocompleteController.text = item.name;
        selectedRepeat = item;
      }),
      key: _autocompleteKey,
      focusNode: widget.node,
      textInputAction: TextInputAction.done,
      suggestions:
          (BlocProvider.of<RepeatsBloc>(context).state as RepeatsLoaded)
              .repeats,
      itemBuilder: (context, suggestion) => Padding(
        child: ListTile(
            title: Text(suggestion.name),
            trailing: Text(
              // Todo: Improve this translation
              '${JsonIntl.of(context).get(IntlKeys.interval)} ${suggestion.mileageInterval}',
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
      textSubmitted: (_) {},
    );
    return FormField<String>(
      builder: (FormFieldState<String> input) {
        // workaround because the autocomplete controller seems to clear it?
        _autocompleteController.text = selectedRepeat?.name ?? '';
        return autoCompleteField;
      },
      initialValue: widget.todo?.repeatName ?? '',
      validator: (val) {
        final txt = _autocompleteController.text;
        if (widget.requireInput) {
          final res = requiredValidator(txt);
          // TODO figure this out better
          // if (selectedCar != null)
          //   widget.refueling.carName = selectedCar.name;
          // else if (val != null && cars.any((element) => element.name == val)) {
          //   widget.refueling.carName = val;
          // }
          autoCompleteField.updateDecoration(
            decoration: defaultInputDecoration(
                    JsonIntl.of(context).get(IntlKeys.requiredLiteral),
                    JsonIntl.of(context).get(IntlKeys.carName))
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
