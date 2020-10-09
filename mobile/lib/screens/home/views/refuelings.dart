import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_intl/json_intl.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../redux/redux.dart';
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
    return refuelings.any((r) =>
        roundToDay(r.odomSnapshot.date).isAtSameMomentAs(roundToDay(date)));
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
    BlocProvider.of<DataBloc>(context).add(DeleteRefueling(refueling));
    Scaffold.of(context).showSnackBar(DeleteRefuelingSnackBar(
      context: context,
      onUndo: () =>
          BlocProvider.of<DataBloc>(context).add(AddRefueling(refueling)),
    ));
  }

  @override
  Widget build(BuildContext context) => StoreConnector(
        converter: _ViewModel.fromStore,
        builder: (context, vm) => Container(
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return _PanelButtons();
                    } else if (index == 1) {
                      return _CalendarView(
                        refuelings: vm.refuelings,
                      );
                    }

                    final adjustedIndex = index - 2;
                    return RefuelingCard(
                      first: adjustedIndex == 0,
                      last: adjustedIndex == (vm.refuelings.length - 1),
                      refueling: vm.refuelings[adjustedIndex],
                      car: vm.cars.firstWhere(
                          (c) => c.id == vm.refuelings[adjustedIndex].carId),
                      onDelete: () => vm.onDeleteRefueling(
                          context, vm.refuelings[adjustedIndex]),
                    );
                  },
                  childCount: vm.refuelings.length + 2,
                ),
              ),
              SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: (vm.refuelings.isEmpty)
                      ? Center(
                          child: Text(
                              JsonIntl.of(context).get(IntlKeys.noRefuelings)))
                      : Container(),
                ),
              )
            ],
          ),
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel(
      {@required this.refuelings,
      @required this.cars,
      @required this.onDeleteRefueling});

  final List<Refueling> refuelings;
  final List<Car> cars;
  final Function(BuildContext, Refueling) onDeleteRefueling;

  static _ViewModel fromStore(Store<AppState> store) {
    if (store.state.dataState.status == DataStatus.IDLE) {
      store.dispatch(fetchData());
    }
    return _ViewModel(
        // TODO: add filtering
        refuelings: store.state.dataState.refuelings,
        cars: store.state.dataState.cars,
        onDeleteRefueling: (context, refueling) {
          store.dispatch(deleteRefueling(refueling));
          Scaffold.of(context).showSnackBar(DeleteRefuelingSnackBar(
            context: context,
            onUndo: () => store.dispatch(createRefueling(refueling)),
          ));
        });
  }

  @override
  List get props => [refuelings];
}
