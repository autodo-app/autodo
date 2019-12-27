import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/screens/add_edit/barrel.dart';
import 'views/barrel.dart';

class HomeScreen extends StatelessWidget {
  final Map<AppTab, Widget> views = {
    AppTab.todos: TodosScreen(),
    AppTab.refuelings: RefuelingsScreen(),
    AppTab.stats: StatisticsScreen(),
    AppTab.repeats: RepeatsScreen(),
  };
  final Key todosTabKey;
  final bool integrationTest;
  final List<MaterialPageRoute> fabRoutes = [
    MaterialPageRoute(  
      builder: (context) => RefuelingAddEditScreen(
        isEditing: false,
        onSave: (m, d, a, c, n) {
          BlocProvider.of<RefuelingsBloc>(context).add(  
            AddRefueling(Refueling(
              mileage: m,
              date: d,
              amount: a,
              cost: c,
              carName: n,
            ))
          );
        },
      ),
    ),
    MaterialPageRoute(
      builder: (context) => TodoAddEditScreen(
        isEditing: false,
        onSave: (d, m, r, c) {
          for (var car in c) {
            BlocProvider.of<TodosBloc>(context).add(  
              AddTodo(Todo(  
                dueDate: d,
                dueMileage: m,
                repeatName: r,
                carName: car
              ))
            );
          }
        },
      )
    ),
    MaterialPageRoute(  
      builder: (context) => RepeatAddEditScreen(
        isEditing: false,
        onSave: (n, i, c) {
          BlocProvider.of<RepeatsBloc>(context).add(  
            AddRepeat(Repeat(  
              name: n,
              mileageInterval: i,
              cars: c
            ))
          );
        },
      )
    )
  ];

  HomeScreen({Key key = IntegrationTestKeys.homeScreen, this.todosTabKey, this.integrationTest}) : super(key: key);

  Widget get actionButton => (integrationTest ?? false) ? 
    AutodoActionButton(miniButtonRoutes: fabRoutes, ticker: TestVSync()) : 
    AutodoActionButton(miniButtonRoutes: fabRoutes);

  @override 
  build(context) => BlocBuilder<TabBloc, AppTab>( 
    builder: (context, activeTab) => Scaffold(  
      appBar: AppBar(  
        title: Text(AutodoLocalizations.appTitle),
        actions: [ExtraActions()],
      ),
      body: views[activeTab],
      floatingActionButton: actionButton,
      bottomNavigationBar: TabSelector(  
        activeTab: activeTab,
        onTabSelected: (tab) =>
          BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
        todosTabKey: todosTabKey,
      )
    )
  );
}