import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:json_intl/json_intl.dart';
import 'package:pref/pref.dart';

import '../../generated/localization.dart';
import '../../redux/redux.dart';
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

class _DeleteAccountDialog extends StatelessWidget {
  const _DeleteAccountDialog(this.vm);

  final _ViewModel vm;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(JsonIntl.of(context).get(IntlKeys.deleteAccount)),
        content: Text(JsonIntl.of(context).get(IntlKeys.deleteAccountMessage),
            style: Theme.of(context).primaryTextTheme.bodyText2),
        actions: <Widget>[
          FlatButton(
              key: ValueKey('__delete_account_confirm__'),
              onPressed: () {
                vm.onDeleteAccount();
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

class _Body extends StatelessWidget {
  const _Body(this.vm);

  final _ViewModel vm;

  @override
  Widget build(BuildContext context) => PrefPage(children: [
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
              child:
                  Text(JsonIntl.of(context).get(IntlKeys.fuelGallonsImperial)),
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
              child:
                  Text(JsonIntl.of(context).get(IntlKeys.efficiencyMpigShort)),
            ),
            DropdownMenuItem(
              value: EfficiencyUnit.kmpl.index,
              child:
                  Text(JsonIntl.of(context).get(IntlKeys.efficiencyKmplShort)),
            ),
            DropdownMenuItem(
              value: EfficiencyUnit.lp100km.index,
              child: Text(
                  JsonIntl.of(context).get(IntlKeys.efficiencyLp100kmShort)),
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
              vm.onLogOut();
              Navigator.pop(context);
            }),
        PrefButton(
          child: Text(JsonIntl.of(context).get(IntlKeys.deleteAccount)),
          key: ValueKey('__delete_account_button__'),
          color: Colors.red,
          onTap: () async {
            if (await showDialog<bool>(
                  context: context,
                  builder: (context) => _DeleteAccountDialog(vm),
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

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, // used to avoid overflow when keyboard is viewable
      appBar: AppBar(
        title: Text(JsonIntl.of(context).get(IntlKeys.settings)),
      ),
      body: StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) => _Body(vm),
      ),
    );
  }
}

class _ViewModel extends Equatable {
  const _ViewModel({@required this.onDeleteAccount, @required this.onLogOut});

  final Function() onDeleteAccount;
  final Function() onLogOut;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        onDeleteAccount: store.dispatch(deleteAccount()),
        onLogOut: store.dispatch(logOut()),
      );

  @override
  List get props => [];
}
