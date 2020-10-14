import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../redux/redux.dart';
import '../../../theme.dart';
import '../../../util.dart';

enum DateRepeatInterval { NEVER, WEEKLY, MONTHLY, YEARLY, CUSTOM }
const Map<DateRepeatInterval, RepeatInterval> dateIntervals = {
  DateRepeatInterval.NEVER: null,
  DateRepeatInterval.WEEKLY: RepeatInterval(days: 7),
  DateRepeatInterval.MONTHLY: RepeatInterval(months: 1),
  DateRepeatInterval.YEARLY: RepeatInterval(years: 1),
  DateRepeatInterval.CUSTOM: null,
};

/// Modeled off of the design of the Android Calendar app's repeat interval
/// selector.
///
/// Requires the onSaved parameter as a callback for filling in the form's data
/// when it is saved.
class RepeatIntervalSelector extends StatefulWidget {
  const RepeatIntervalSelector(
      {Key key, @required this.onSaved, this.initialMileage, this.initialDate})
      : super(key: key);

  final Function(double, RepeatInterval) onSaved;
  final double initialMileage;
  final RepeatInterval initialDate;
  static const Map<DateRepeatInterval, ValueKey> radioKeys = {
    DateRepeatInterval.NEVER: ValueKey('NEVER'),
    DateRepeatInterval.WEEKLY: ValueKey('WEEKLY'),
    DateRepeatInterval.MONTHLY: ValueKey('MONTHLY'),
    DateRepeatInterval.YEARLY: ValueKey('YEARLY'),
    DateRepeatInterval.CUSTOM: ValueKey('CUSTOM'),
  };

  @override
  RepeatIntervalSelectorState createState() => RepeatIntervalSelectorState();
}

DateRepeatInterval _mapDateIntervalBackwards(RepeatInterval duration) {
  return dateIntervals.keys.firstWhere((k) => dateIntervals[k] == duration,
      orElse: () => DateRepeatInterval.CUSTOM);
}

class _MileageRepeatSelector extends StatelessWidget {
  const _MileageRepeatSelector({@required this.onSaved, this.initial});

  final Function(double) onSaved;
  final double initial;

  @override
  Widget build(BuildContext context) => Container(
        child: StoreBuilder(
          builder: (BuildContext context, Store<AppState> store) =>
              TextFormField(
            decoration: defaultInputDecoration(
              context,
              JsonIntl.of(context).get(IntlKeys.mileageInterval),
              unit: store.state.unitsState.distance
                  .unitString(store.state.intlState.intl, short: true),
            ),
            keyboardType: TextInputType.number,
            initialValue: initial == null ? '' : '$initial',
            validator: doubleNoRequire,
            onSaved: (val) =>
                onSaved((val == null || val == '') ? null : double.parse(val)),
          ),
        ),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
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
                key: RepeatIntervalSelector.radioKeys[DateRepeatInterval.NEVER],
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
                key:
                    RepeatIntervalSelector.radioKeys[DateRepeatInterval.WEEKLY],
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
                key: RepeatIntervalSelector
                    .radioKeys[DateRepeatInterval.MONTHLY],
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
                key:
                    RepeatIntervalSelector.radioKeys[DateRepeatInterval.YEARLY],
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
                key:
                    RepeatIntervalSelector.radioKeys[DateRepeatInterval.CUSTOM],
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
        )),
        validator: (_) => null,
        onSaved: widget.onSaved(_interval),
      );
}

class RepeatIntervalSelectorState extends State<RepeatIntervalSelector> {
  double _mileageInterval;
  RepeatInterval dateInterval;
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
                widget.onSaved(_mileageInterval, dateInterval);
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(children: [
              _MileageRepeatSelector(
                onSaved: (interval) => _mileageInterval = interval,
                initial: widget.initialMileage,
              ),
              Container(
                child: Divider(),
                padding: EdgeInsets.all(10),
              ),
              Center(
                child: Text('Date Repeat Interval'),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              _DateRepeatSelector(
                onSaved: (interval) {
                  dateInterval = dateIntervals[interval];
                },
                initial: _mapDateIntervalBackwards(widget.initialDate),
              ),
            ]),
          ),
        ),
      );
}
