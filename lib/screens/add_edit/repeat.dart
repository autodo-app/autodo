import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/units/units.dart';
import 'package:autodo/util.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import 'forms/barrel.dart';

typedef _OnSaveCallback = Function(
  String name,
  double mileageInterval,
  List<String> carNames,
);

class _NameForm extends StatelessWidget {
  const _NameForm({this.repeat, this.onSaved, this.node, this.nextNode});

  final Repeat repeat;

  final FocusNode node, nextNode;

  final Function(String) onSaved;

  @override
  Widget build(context) => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          labelText: JsonIntl.of(context).get(IntlKeys.actionName),
          contentPadding:
              EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
        ),
        initialValue: repeat?.name ?? '',
        autofocus: true,
        focusNode: node,
        style: Theme.of(context).primaryTextTheme.subtitle2,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        validator: requiredValidator,
        onSaved: onSaved,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => changeFocus(node, nextNode),
      );
}

class _MileageForm extends StatelessWidget {
  const _MileageForm({this.repeat, this.onSaved, this.node, this.nextNode});

  final Repeat repeat;

  final FocusNode node, nextNode;

  final Function(String) onSaved;

  @override
  Widget build(context) {
    final distance = Distance.of(context);

    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
        ),
        labelText: JsonIntl.of(context).get(IntlKeys.mileageInterval),
        contentPadding:
            EdgeInsets.only(left: 16.0, top: 20.0, right: 16.0, bottom: 5.0),
      ),
      initialValue: distance.format(repeat?.mileageInterval, textField: true),
      autofocus: false,
      focusNode: node,
      style: Theme.of(context).primaryTextTheme.subtitle2,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      validator: requiredValidator,
      onSaved: onSaved,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => changeFocus(node, nextNode),
    );
  }
}

class RepeatAddEditScreen extends StatefulWidget {
  const RepeatAddEditScreen({
    Key key = const ValueKey('__add_edit_repeat__'),
    @required this.onSave,
    @required this.isEditing,
    this.repeat,
  }) : super(key: key);

  final bool isEditing;

  final _OnSaveCallback onSave;

  final Repeat repeat;

  @override
  _RepeatAddEditScreenState createState() => _RepeatAddEditScreenState(repeat);
}

class _RepeatAddEditScreenState extends State<RepeatAddEditScreen> {
  _RepeatAddEditScreenState(this.repeat);

  Repeat repeat;

  FocusNode _nameNode, _mileageNode;

  final _formKey = GlobalKey<FormState>();

  ScrollController scrollCtrl;

  String _name;

  double _mileageInterval;

  List<Map<String, dynamic>> _cars;

  bool get isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    _nameNode = FocusNode();
    _mileageNode = FocusNode();
    scrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _mileageNode.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(context) => Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            isEditing
                ? JsonIntl.of(context).get(IntlKeys.editRepeat)
                : JsonIntl.of(context).get(IntlKeys.addRepeat),
          ),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.all(15),
                child: ListView(
                  controller: scrollCtrl,
                  children: <Widget>[
                    AutoScrollField(
                      controller: scrollCtrl,
                      child: _NameForm(
                        repeat: repeat,
                        node: _nameNode,
                        nextNode: _mileageNode,
                        onSaved: (val) => _name = val,
                      ),
                      focusNode: _nameNode,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    AutoScrollField(
                      controller: scrollCtrl,
                      child: _MileageForm(
                        repeat: repeat,
                        node: _mileageNode,
                        onSaved: (val) => _mileageInterval = double.parse(val),
                      ),
                      focusNode: _mileageNode,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    BlocBuilder<CarsBloc, CarsState>(
                      builder: (context, state) {
                        if (state is CarsLoaded) {
                          return CarsCheckboxForm(
                            cars: state.cars,
                            onSaved: (cars) => _cars = cars,
                          );
                        }
                        return LoadingIndicator();
                      },
                    ),
                    // so there is some padding to fill the bottom of the screen
                    // when autoscrolling up
                    Container(
                      height: 10000,
                    ),
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          tooltip: isEditing
              ? JsonIntl.of(context).get(IntlKeys.saveChanges)
              : JsonIntl.of(context).get(IntlKeys.addRefueling),
          child: Icon(isEditing ? Icons.check : Icons.add),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              final carNames = <String>[];
              for (var car in _cars) {
                if (car['enabled']) {
                  carNames.add(car['name'] as String);
                }
              }
              widget.onSave(_name, _mileageInterval, carNames);
              Navigator.pop(context);
            }
          },
        ),
      );
}
