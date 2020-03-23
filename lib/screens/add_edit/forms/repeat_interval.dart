import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/generated/localization.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/util.dart';

/// Modeled off of the design of the Android Calendar app's repeat interval
/// selector.
///
/// Requires the onSaved parameter as a callback for filling in the form's data
/// when it is saved.
class RepeatIntervalSelector extends StatefulWidget {
  const RepeatIntervalSelector({@required this.onSaved, this.existingTodo});

  final Function(double, Duration) onSaved;
  final Todo existingTodo;

  @override
  _RepeatIntervalSelectorState createState() => _RepeatIntervalSelectorState();
}

enum DateRepeatInterval { NEVER, WEEKLY, MONTHLY, YEARLY, CUSTOM }
const Map<DateRepeatInterval, Duration> dateIntervals = {
  DateRepeatInterval.NEVER: null,
  DateRepeatInterval.WEEKLY: Duration(days: 7),
  // TODO: Dart doesn't natively support incrementing by months or years
  DateRepeatInterval.MONTHLY: null,
  DateRepeatInterval.YEARLY: null,
  DateRepeatInterval.CUSTOM: null,
};

DateRepeatInterval _mapDateIntervalBackwards(Duration duration) {
  return dateIntervals.keys.firstWhere(
    (k) => dateIntervals[k] == duration, orElse: () => DateRepeatInterval.CUSTOM);
}

class _MileageRepeatSelector extends StatelessWidget {
  const _MileageRepeatSelector({@required this.onSaved, this.initial});

  final Function(double) onSaved;
  final double initial;

  @override
  Widget build(BuildContext context) => Container(
    child: Row(
      children: [
        Text(JsonIntl.of(context).get(IntlKeys.mileage)),
        TextFormField(
          decoration: defaultInputDecoration(
            JsonIntl.of(context).get(IntlKeys.requiredLiteral),
            JsonIntl.of(context).get(IntlKeys.mileageInterval)),
          keyboardType: TextInputType.number,
          initialValue: '$initial',
          validator: doubleValidator,
          onSaved: (val) => onSaved(double.parse(val)),
        ),
      ],
    ),
    padding: EdgeInsets.all(5),
  );
}

class _DateRepeatSelector extends StatefulWidget {
  const _DateRepeatSelector({@required this.onSaved, this.initial});

  final Function(DateRepeatInterval) onSaved;
  final DateRepeatInterval initial;

  @override
  _DateRepeatSelectorState createState() => _DateRepeatSelectorState(initial);
}

class _DateRepeatSelectorState extends State<_DateRepeatSelector> {
  _DateRepeatSelectorState(initial) {
    _interval = initial;
  }

  DateRepeatInterval _interval;

  @override
  Widget build(BuildContext context) => FormField(
    builder: (state) => Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(JsonIntl.of(context).get(IntlKeys.never)),
            leading: Radio(
              value: DateRepeatInterval.NEVER,
              groupValue: _interval,
              onChanged: (value) {
                setState(() {
                  _interval = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(JsonIntl.of(context).get(IntlKeys.weekly)),
            leading: Radio(
              value: DateRepeatInterval.WEEKLY,
              groupValue: _interval,
              onChanged: (value) {
                setState(() {
                  _interval = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(JsonIntl.of(context).get(IntlKeys.monthly)),
            leading: Radio(
              value: DateRepeatInterval.MONTHLY,
              groupValue: _interval,
              onChanged: (value) {
                setState(() {
                  _interval = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(JsonIntl.of(context).get(IntlKeys.yearly)),
            leading: Radio(
              value: DateRepeatInterval.YEARLY,
              groupValue: _interval,
              onChanged: (value) {
                setState(() {
                  _interval = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text(JsonIntl.of(context).get(IntlKeys.custom)),
            leading: Radio(
              value: DateRepeatInterval.CUSTOM,
              groupValue: _interval,
              onChanged: (value) {
                setState(() {
                  _interval = value;
                });
              },
            ),
          ),
        ],
      )
    ),
    validator: (_) => null,
    onSaved: widget.onSaved(_interval),
  );
}

class _RepeatIntervalSelectorState extends State<RepeatIntervalSelector> {
  double _mileageInterval;
  Duration _dateInterval;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(JsonIntl.of(context).get(IntlKeys.repeatCaps)),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onSaved(_mileageInterval, _dateInterval);
            Navigator.pop(context);
          }
        },
      ),
    ),
    body: ListView(
      children: [
        Text('Mileage Repeat Interval'),
        _MileageRepeatSelector(
          onSaved: (interval) => _mileageInterval = interval,
          initial: widget.existingTodo?.mileageRepeatInterval,),
        Padding(padding: EdgeInsets.all(10),),
        Text('Date Repeat Interval'),
        _DateRepeatSelector(
          onSaved: (interval) => _dateInterval = dateIntervals[interval],
          initial: _mapDateIntervalBackwards(widget.existingTodo?.dateRepeatInterval),),
      ]
    ),
  );
}
