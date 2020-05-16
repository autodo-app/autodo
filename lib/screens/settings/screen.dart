import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';
import 'package:pref/pref.dart';

import '../../blocs/blocs.dart';
import '../../generated/localization.dart';

import '../../units/units.dart';
import '../about/about.dart';

class SettingsScreen extends StatefulWidget {
  static Future<void> show(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(),
      ),
    );
  }

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
              // AutodoRoutes.welcome
              Navigator.pop(context, true);
            },
            child: Text(JsonIntl.of(context).get(IntlKeys.yes),
                style: Theme.of(context)
                    .primaryTextTheme
                    .button
                    .copyWith(color: Colors.red))),
        FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(JsonIntl.of(context).get(IntlKeys.no),
                style: Theme.of(context)
                    .primaryTextTheme
                    .button
                    .copyWith(color: Theme.of(context).accentColor))),
      ],
    );
  }

  Widget body() {
    return PrefPage(children: [
      PrefTitle(title: Text(JsonIntl.of(context).get(IntlKeys.groupUnits))),
      PrefDropdown<int>(
        title: Text(JsonIntl.of(context).get(IntlKeys.lengthUnit)),
        pref: 'length_unit',
        items: [
          DropdownMenuItem(
            value: DistanceUnit.metric.index,
            child: Text(JsonIntl.of(context).get(IntlKeys.distanceKm)),
          ),
          DropdownMenuItem(
            value: DistanceUnit.imperial.index,
            child: Text(JsonIntl.of(context).get(IntlKeys.distanceMiles)),
          )
        ],
      ),
      PrefDropdown<int>(
        title: Text(JsonIntl.of(context).get(IntlKeys.volumeUnit)),
        pref: 'volume_unit',
        items: [
          DropdownMenuItem(
            value: VolumeUnit.metric.index,
            child: Text(JsonIntl.of(context).get(IntlKeys.fuelLiters)),
          ),
          DropdownMenuItem(
            value: VolumeUnit.imperial.index,
            child: Text(JsonIntl.of(context).get(IntlKeys.fuelGallonsImperial)),
          ),
          DropdownMenuItem(
            value: VolumeUnit.us.index,
            child: Text(JsonIntl.of(context).get(IntlKeys.fuelGallonsUs)),
          ),
        ],
      ),
      PrefDropdown<int>(
        title: Text(JsonIntl.of(context).get(IntlKeys.efficiencyUnit)),
        pref: 'efficiency_unit',
        items: [
          DropdownMenuItem(
            value: EfficiencyUnit.mpusg.index,
            child:
                Text(JsonIntl.of(context).get(IntlKeys.efficiencyMpusgShort)),
          ),
          DropdownMenuItem(
            value: EfficiencyUnit.mpig.index,
            child: Text(JsonIntl.of(context).get(IntlKeys.efficiencyMpigShort)),
          ),
          DropdownMenuItem(
            value: EfficiencyUnit.kmpl.index,
            child: Text(JsonIntl.of(context).get(IntlKeys.efficiencyKmplShort)),
          ),
          DropdownMenuItem(
            value: EfficiencyUnit.lp100km.index,
            child:
                Text(JsonIntl.of(context).get(IntlKeys.efficiencyLp100kmShort)),
          ),
        ],
      ),
      PrefDropdown<String>(
        title: Text(JsonIntl.of(context).get(IntlKeys.defaultCurrency)),
        pref: 'currency',
        items: Currency.currencies.keys
            .map<DropdownMenuItem<String>>(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
      ),
      PrefTitle(title: Text(JsonIntl.of(context).get(IntlKeys.groupAccount))),
      PrefButton(
          child: Text(JsonIntl.of(context).get(IntlKeys.signOut)),
          key: ValueKey('__sign_out_button__'),
          color: Theme.of(context).buttonTheme.colorScheme.background,
          onTap: () {
            BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
            Navigator.pop(context);
          }),
      PrefButton(
        child: Text(JsonIntl.of(context).get(IntlKeys.deleteAccount)),
        key: ValueKey('__delete_account_button__'),
        color: Colors.red,
        onTap: () async {
          if (await showDialog<bool>(
                context: context,
                builder: (context) => deleteAccountDialog(),
              ) ==
              true) Navigator.pop(context);
        },
      ),
      PrefTitle(title: Text(JsonIntl.of(context).get(IntlKeys.info))),
      PrefButton(
        child: Text(MaterialLocalizations.of(context)
            .aboutListTileTitle(JsonIntl.of(context).get(IntlKeys.appTitle))),
        color: Theme.of(context).buttonTheme.colorScheme.background,
        onTap: () {
          about(context);
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, // used to avoid overflow when keyboard is viewable
      appBar: AppBar(
        title: Text(JsonIntl.of(context).get(IntlKeys.settings)),
      ),
      body: body(),
    );
  }
}
