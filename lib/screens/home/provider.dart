import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';

import 'screen.dart';

/// Structures the BlocProviders for the homescreen and exports them for
/// use by the main screen.
class HomeScreenProvider extends StatelessWidget {
  const HomeScreenProvider({this.integrationTest});

  final bool integrationTest;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<TabBloc>(
            create: (context) => TabBloc(),
          ),
          BlocProvider<FilteredTodosBloc>(
            create: (context) => FilteredTodosBloc(
              todosBloc: BlocProvider.of<TodosBloc>(context),
            ),
          ),
          BlocProvider<FilteredRefuelingsBloc>(
            create: (context) => FilteredRefuelingsBloc(
                carsBloc: BlocProvider.of<CarsBloc>(context),
                refuelingsBloc: BlocProvider.of<RefuelingsBloc>(context)),
          ),
          BlocProvider<EfficiencyStatsBloc>(
            create: (context) => EfficiencyStatsBloc(
              refuelingsBloc: BlocProvider.of<RefuelingsBloc>(context),
            )..add(LoadEfficiencyStats()),
          ),
          BlocProvider<DrivingDistanceStatsBloc>(
            create: (context) => DrivingDistanceStatsBloc(
              carsBloc: BlocProvider.of<CarsBloc>(context),
            )..add(LoadDrivingDistanceStats()),
          )
        ],
        child: HomeScreen(integrationTest: integrationTest),
      );
}
