import 'package:autodo/localization.dart';
import 'package:autodo/units/units.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/routes.dart';
import 'package:json_intl/json_intl.dart';
import 'package:preferences/preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  Widget deleteAccountDialog() {
    return AlertDialog(
      title: Text(JsonIntl.of(context).get(IntlKeys.deleteAccount)),
      content: Text(JsonIntl.of(context).get(IntlKeys.deleteAccountMessage),
          style: Theme.of(context).primaryTextTheme.bodyText2),
      actions: <Widget>[
        FlatButton(
            key: ValueKey('__delete_account_confirm__'),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(DeletedUser());
              Navigator.popAndPushNamed(context, AutodoRoutes.welcome);
            },
            child: Text(JsonIntl.of(context).get(IntlKeys.yes),
                style: Theme.of(context)
                    .primaryTextTheme
                    .button
                    .copyWith(color: Colors.red))),
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(JsonIntl.of(context).get(IntlKeys.no),
                style: Theme.of(context)
                    .primaryTextTheme
                    .button
                    .copyWith(color: Theme.of(context).accentColor))),
      ],
    );
  }

  Widget body() {
    return PreferencePage([
      PreferenceTitle(JsonIntl.of(context).get(IntlKeys.groupUnits)),
      DropdownPreference<int>(
        JsonIntl.of(context).get(IntlKeys.lengthUnit),
        'length_unit',
        displayValues: [
          JsonIntl.of(context).get(IntlKeys.distanceKm),
          JsonIntl.of(context).get(IntlKeys.distanceMiles),
        ],
        values: [
          DistanceUnit.metric.index,
          DistanceUnit.imperial.index,
        ],
      ),
      DropdownPreference<int>(
        JsonIntl.of(context).get(IntlKeys.volumeUnit),
        'volume_unit',
        displayValues: [
          JsonIntl.of(context).get(IntlKeys.fuelLiters),
          JsonIntl.of(context).get(IntlKeys.fuelGallonsImperial),
          JsonIntl.of(context).get(IntlKeys.fuelGallonsUs),
        ],
        values: [
          VolumeUnit.metric.index,
          VolumeUnit.imperial.index,
          VolumeUnit.us.index,
        ],
      ),
      DropdownPreference<String>(
        JsonIntl.of(context).get(IntlKeys.defaultCurrency),
        'currency',
        values: Currency.currencies,
      ),
      PreferenceTitle(JsonIntl.of(context).get(IntlKeys.groupMisc)),
      PreferenceButton(
        Text(JsonIntl.of(context).get(IntlKeys.deleteAccount)),
        key: ValueKey('__delete_account_button__'),
        color: Colors.red,
        onTap: () => showDialog(
          context: context,
          builder: (context) => deleteAccountDialog(),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, // used to avoid overflow when keyboard is viewable
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(JsonIntl.of(context).get(IntlKeys.settings)),
      ),
      body: body(),
    );
  }
}
