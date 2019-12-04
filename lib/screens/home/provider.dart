import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/todos/barrel.dart';
import 'blocs/barrel.dart';
import 'screen.dart';

class HomeScreenProvider extends StatelessWidget {
  @override 
  build(BuildContext context) => MultiBlocProvider(
      providers: [
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
        BlocProvider<FilteredTodosBloc>(
          create: (context) => FilteredTodosBloc(
            todosBloc: BlocProvider.of<TodosBloc>(context),
          ),
        ),
        BlocProvider<StatsBloc>(
          create: (context) => StatsBloc(
            todosBloc: BlocProvider.of<TodosBloc>(context),
          ),
        ),
      ],
      child: HomeScreen(),
  );
}
