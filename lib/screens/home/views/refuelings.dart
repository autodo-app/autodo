import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';
import 'package:intl/intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../theme.dart';
import '../../../util.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';
import 'constants.dart';

class _PanelButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ButtonTheme.fromButtonThemeData(
            data: ButtonThemeData(
              minWidth: 0,
            ),
            child: FlatButton(
              child: Icon(Icons.search),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                showDialog(
                    context: context,
                    child: AlertDialog(
                        title: Text(JsonIntl.of(context)
                            .get(IntlKeys.toBeImplemented))));
              },
            ),
          ),
          // ExtraActions(), // TODO: filter by car or something here?
          SizedBox(
            width: 10,
          ), // padding
        ],
      ));
}

class _Circle extends StatelessWidget {
  const _Circle({this.color, this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(size),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        width: size,
        height: size,
      );
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({Key key, this.name, this.number, this.refuelingToday})
      : super(key: key);

  final bool refuelingToday;
  final String name;
  final int number;

  TextStyle _textStyle(BuildContext context) => (number == DateTime.now().day)
      ? Theme.of(context)
          .primaryTextTheme
          .bodyText2
          .copyWith(color: Theme.of(context).primaryColor)
      : Theme.of(context).primaryTextTheme.bodyText2;

  @override
  Widget build(BuildContext context) => Flexible(
      // marked as flexible to prevent renderflex in widget testing
      child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Text(
                name,
                // JsonIntl.of(context).get(name),
                style: _textStyle(context),
              ),
              Text(
                number.toString(),
                style: _textStyle(context),
              ),
              if (refuelingToday)
                _Circle(color: _textStyle(context).color, size: 5.0)
            ],
          )));
}

class _CalendarView extends StatelessWidget {
  const _CalendarView({Key key, @required this.refuelings}) : super(key: key);

  final List<Refueling> refuelings;

  bool _refuelingToday(DateTime date) {
    return refuelings
        .any((r) => roundToDay(r.date).isAtSameMomentAs(roundToDay(date)));
  }

  DateTime _getInterval(int dateDay, int dayRangeVal) =>
      RepeatInterval(days: dayRangeVal - dateDay).addToDate(DateTime.now());

  /// Returns the day value adjusted so that values from the upcoming month
  /// and past month are correct.
  ///
  /// Using the next month with a day value of 0 returns the last day of the
  /// current month.
  int _checkRollover(int day) {
    final thisLastDay =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    final pastLastDay =
        DateTime(DateTime.now().year, DateTime.now().month, 0).day;
    if (day > thisLastDay) {
      return day - thisLastDay;
    } else if (day < 1) {
      return day + pastLastDay;
    }
    return day;
  }

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = DateTime.now().weekday;
    final dateDay = DateTime.now().day;
    // Raw range is used to calculate the DateTime for each day when searching
    // for matching refuelings
    final dayRangeRaw =
        List.generate(7, (index) => index + dateDay - dayOfWeek);
    // The display day range accounts for past and future month rollovers so the
    // dates are correct per the calendar
    final displayDayRange = dayRangeRaw.map(_checkRollover).toList();

    return ClipRect(
        child: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  7, // days in a week
                  (index) => _CalendarDay(
                      name: DateFormat.E().format(DateTime.now()
                          .subtract(Duration(days: dayOfWeek))
                          .add(Duration(days: index))),
                      number: displayDayRange[index],
                      refuelingToday: _refuelingToday(
                          _getInterval(dateDay, dayRangeRaw[index])))),
            )));
  }
}

class RefuelingsScreen extends StatelessWidget {
  const RefuelingsScreen({Key key}) : super(key: key);

  void _deleteRefueling(BuildContext context, Refueling refueling) {
    BlocProvider.of<RefuelingsBloc>(context).add(DeleteRefueling(refueling));
    Scaffold.of(context).showSnackBar(DeleteRefuelingSnackBar(
      context: context,
      onUndo: () =>
          BlocProvider.of<RefuelingsBloc>(context).add(AddRefueling(refueling)),
    ));
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<CarsBloc, CarsState>(
      builder: (context, carsState) =>
          BlocBuilder<FilteredRefuelingsBloc, FilteredRefuelingsState>(
              builder: (context, refuelingsState) {
            if (!(refuelingsState is FilteredRefuelingsLoaded) ||
                !(carsState is CarsLoaded)) {
              return Container();
            }

            final refuelings = (refuelingsState as FilteredRefuelingsLoaded)
                .filteredRefuelings;
            final cars = (carsState as CarsLoaded).cars;
            return Container(
                decoration: headerDecoration,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: HEADER_HEIGHT,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          JsonIntl.of(context).get(IntlKeys.refuelings),
                          style: Theme.of(context).accentTextTheme.headline1,
                        ),
                        titlePadding: EdgeInsets.all(25),
                        centerTitle: true,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          return _PanelButtons();
                        } else if (index == 1) {
                          return _CalendarView(
                            refuelings: refuelings,
                          );
                        }

                        final adjustedIndex = index - 2;
                        return RefuelingCard(
                          first: adjustedIndex == 0,
                          last: adjustedIndex == (refuelings.length - 1),
                          refueling: refuelings[adjustedIndex],
                          car: cars.firstWhere((c) =>
                              c.name == refuelings[adjustedIndex].carName),
                          onDelete: () => _deleteRefueling(
                              context, refuelings[adjustedIndex]),
                        );
                      }),
                    ),
                  ],
                ));
          }));
}
