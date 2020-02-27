import 'package:autodo/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/models/models.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/screens/add_edit/repeat.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:json_intl/json_intl.dart';

class _RepeatTitle extends StatelessWidget {
  final Repeat repeat;

  const _RepeatTitle(this.repeat, {Key key}) : super(key: key);

  @override
  build(context) => Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: JsonIntl.of(context).get(IntlKeys.task) + ' ',
                style: Theme.of(context).primaryTextTheme.body1),
            TextSpan(
                text: repeat.name,
                style: Theme.of(context).primaryTextTheme.subtitle),
          ]),
        ),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: JsonIntl.of(context).get(IntlKeys.interval) + ' ',
              style: Theme.of(context).primaryTextTheme.body1),
          TextSpan(
              text: repeat.mileageInterval.toString(),
              style: Theme.of(context).primaryTextTheme.subtitle),
          TextSpan(
              text: ' miles', style: Theme.of(context).primaryTextTheme.body1)
        ]))
      ]));
}

class _RepeatEditButton extends StatelessWidget {
  final Repeat repeat;

  const _RepeatEditButton(this.repeat, {Key key}) : super(key: key);

  @override
  build(context) => ButtonTheme.fromButtonThemeData(
      data: ButtonThemeData(
        minWidth: 0,
      ),
      child: FlatButton(
        key: ValueKey('__repeat_card_edit_${repeat.name}'),
        child: const Icon(Icons.edit),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RepeatAddEditScreen(
                    repeat: repeat,
                    isEditing: true,
                    onSave: (n, i, c) => BlocProvider.of<RepeatsBloc>(context)
                        .add(UpdateRepeat(repeat.copyWith(
                            name: n, mileageInterval: i, cars: c)))))),
      ));
}

class _RepeatDeleteButton extends StatelessWidget {
  final Repeat repeat;

  const _RepeatDeleteButton(this.repeat, {Key key}) : super(key: key);

  @override
  build(context) => ButtonTheme.fromButtonThemeData(
      data: ButtonThemeData(
        minWidth: 0,
      ),
      child: FlatButton(
        key: ValueKey('__repeat_delete_button_${repeat.name}'),
        child: const Icon(Icons.delete),
        onPressed: () {
          BlocProvider.of<RepeatsBloc>(context).add(DeleteRepeat(repeat));
          Scaffold.of(context).showSnackBar(
            DeleteRepeatSnackBar(
              context: context,
              onUndo: () =>
                  BlocProvider.of<RepeatsBloc>(context).add(AddRepeat(repeat)),
            ),
          );
        },
      ));
}

class RepeatCard extends StatelessWidget {
  final Repeat repeat;

  const RepeatCard({Key key, @required this.repeat}) : super(key: key);

  @override
  build(context) => Card(
      key: ValueKey('__repeat_card_${repeat.name}'),
      elevation: 4,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _RepeatTitle(repeat),
        Row(
          children: [
            CarTag(text: repeat.cars.first, color: Color(0xffffffff)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _RepeatEditButton(repeat),
                _RepeatDeleteButton(repeat),
              ],
            ),
          ],
        ),
      ]));
}
