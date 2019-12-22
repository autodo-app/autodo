import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/widgets/widgets.dart';
import 'views/barrel.dart';

class HomeScreen extends StatelessWidget {
  final Map<AppTab, Widget> views = {
    AppTab.todos: TodosScreen(),
    AppTab.refuelings: RefuelingsScreen(),
    AppTab.stats: StatisticsScreen(),
    AppTab.repeats: RepeatsScreen(),
  };

  @override 
  build(context) => BlocBuilder<TabBloc, AppTab>( 
    builder: (context, activeTab) => Scaffold(  
      appBar: AppBar(  
        title: Text(AutodoLocalizations.appTitle),
        actions: [ExtraActions()],
      ),
      body: views[activeTab],
      floatingActionButton: AutodoActionButton(),
      bottomNavigationBar: TabSelector(  
        activeTab: activeTab,
        onTabSelected: (tab) =>
          BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
      )
    )
  );
}