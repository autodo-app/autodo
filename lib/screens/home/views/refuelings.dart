import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../blocs/blocs.dart';
import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../theme.dart';
import '../../../util.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';
import 'constants.dart';

class RefuelingsScreen extends StatelessWidget {
  const RefuelingsScreen({Key key}) : super(key: key);

  void onDismissed(
      DismissDirection direction, BuildContext context, Refueling refueling) {
    BlocProvider.of<RefuelingsBloc>(context).add(DeleteRefueling(refueling));
    Scaffold.of(context).showSnackBar(
      DeleteRefuelingSnackBar(
        context: context,
        onUndo: () => BlocProvider.of<RefuelingsBloc>(context)
            .add(AddRefueling(refueling)),
      ),
    );
  }

  Future<void> onTap(BuildContext context, Refueling refueling) async {
    // final removedRefueling = await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => DetailsScreen(id: refueling.id),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FilteredRefuelingsBloc, FilteredRefuelingsState>(
          builder: (context, state) {
        if (state is FilteredRefuelingsLoading) {
          return LoadingIndicator();
        } else if (state is FilteredRefuelingsLoaded) {
          final refuelings = state.filteredRefuelings;
          return ListView.builder(
              key: ValueKey('__refuelings_screen_scroller__'),
              itemCount: refuelings.length,
              itemBuilder: (context, index) {
                final refueling = refuelings[index];
                return Padding(
                  padding: (index == refuelings.length - 1)
                      ? EdgeInsets.fromLTRB(10, 5, 10, 100)
                      : // add extra padding for last card
                      EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: RefuelingCard(
                      refueling: refueling,
                      onDismissed: (direction) =>
                          onDismissed(direction, context, refueling),
                      onTap: () => onTap(context, refueling)),
                );
              });
        } else {
          return Container();
        }
      });
}

class _PanelButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
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
      ExtraActions(),
      SizedBox(
        width: 10,
      ), // padding
    ],
  );
}

class _Circle extends StatelessWidget {
  const _Circle({this.color, this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.all(size),
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle
    ),
    width: size,
    height: size,
  );
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({Key key, this.name, this.number, this.refuelingToday}) : super(key: key);

  final bool refuelingToday;
  final String name;
  final int number;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(5),
    child: Column(
      children: [
        Text(JsonIntl.of(context).get(name)),
        Text(number.toString()),
        if (refuelingToday)
          _Circle(color: Colors.grey, size: 5.0)
      ],
    )
  );
}

const weekdays = [
  IntlKeys.sunShort,
  IntlKeys.monShort,
  IntlKeys.tueShort,
  IntlKeys.wedShort,
  IntlKeys.thuShort,
  IntlKeys.friShort,
  IntlKeys.satShort,
];

class _CalendarView extends StatelessWidget {
  const _CalendarView({Key key, @required this.refuelings}) : super(key: key);

  final List<Refueling> refuelings;

  bool _refuelingToday(DateTime date) {
    print(date);
    return refuelings.any((r) => roundToDay(r.date).isAtSameMomentAs(roundToDay(date)));
  }

  DateTime _getInterval(int dateDay, int dayRangeVal) =>
    RepeatInterval(days: dayRangeVal - dateDay).addToDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = DateTime.now().weekday;
    final dateDay = DateTime.now().day;
    final dayRange = List.generate(7, (index) => index + dateDay - dayOfWeek);

    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          7, // days in a week
          (index) =>_CalendarDay(
              name: weekdays[index],
              number: dayRange[index],
              refuelingToday: _refuelingToday(_getInterval(dateDay, dayRange[index])))
        ),
      )
    );
  }
}

class RefuelingsPanel extends StatefulWidget {
  const RefuelingsPanel({Key key, this.refuelings, this.cars}) : super(key: key);

  final List<Refueling> refuelings;
  final List<Car> cars;

  @override
  RefuelingsPanelState createState() => RefuelingsPanelState(refuelings);
}

class RefuelingsPanelState extends State<RefuelingsPanel> {
  RefuelingsPanelState(this.refuelings);

  List<Refueling> refuelings;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
    constraints: BoxConstraints(
      // not sure why 24 works, assuming it's from some padding somewhere
      minHeight: MediaQuery.of(context).size.height -
        HEADER_HEIGHT -
        kBottomNavigationBarHeight -
        24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Theme.of(context).cardColor,
    ),
    child: Column(
      children: [
        _PanelButtons(),
        _CalendarView(refuelings: refuelings,),
        ...List.generate( // TODO: making this a column is really bad for performance
          refuelings.length,
          (index) => RefuelingCard(refueling: refuelings[index],)
        )
      ],
    )
  );
}

class RefuelingsScreen2 extends StatelessWidget {
  const RefuelingsScreen2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<CarsBloc, CarsState>(
    builder: (context, carsState) => BlocBuilder<FilteredRefuelingsBloc, FilteredRefuelingsState>(
      builder: (context, refuelingsState) {
        if (!(refuelingsState is FilteredRefuelingsLoaded) ||
            !(carsState is CarsLoaded)) {
          return Container();
        }

        return Container(
          decoration: headerDecoration,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: HEADER_HEIGHT,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    JsonIntl.of(context).get(IntlKeys.refuelings),
                    style:
                        Theme.of(context).accentTextTheme.headline1,
                  ),
                  titlePadding: EdgeInsets.all(25),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: RefuelingsPanel(
                    refuelings: (refuelingsState as FilteredRefuelingsLoaded).filteredRefuelings,
                    cars: (carsState as CarsLoaded).cars),
              ),
            ],
          ));
      }
    )
  );
}
