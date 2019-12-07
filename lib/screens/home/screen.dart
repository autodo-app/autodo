import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:autodo/localization.dart';
import 'package:autodo/blocs/tab/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/widgets/barrel.dart';

class HomeScreen extends StatelessWidget {
  @override 
  build(context) => BlocBuilder<TabBloc, AppTab>( 
    builder: (context, activeTab) => Scaffold(  
      appBar: AppBar(  
        title: Text(AutodoLocalizations.of(context).appTitle)
      ),
      body: activeTab == AppTab.todos ? FilteredTodos() : Stats(),
      floatingActionButton: AutodoActionButton(),
      bottomNavigationBar: TabSelector(  
        activeTab: activeTab,
        onTabSelected: (tab) =>
          BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
      )
    ),
  );
}