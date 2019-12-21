import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/localization.dart';

class ExtraActions extends StatelessWidget {
  ExtraActions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        if (state is TodosLoaded) {
          bool allComplete =
              (BlocProvider.of<TodosBloc>(context).state as TodosLoaded)
                  .todos
                  .every((todo) => todo.completed);
          return PopupMenuButton<ExtraAction>(
            onSelected: (action) {
              switch (action) {
                case ExtraAction.clearCompleted:
                  BlocProvider.of<TodosBloc>(context).add(ClearCompleted());
                  break;
                case ExtraAction.toggleAllComplete:
                  BlocProvider.of<TodosBloc>(context).add(ToggleAll());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
              PopupMenuItem<ExtraAction>(
                value: ExtraAction.toggleAllComplete,
                child: Text(
                  allComplete
                      ? AutodoLocalizations.markAllIncomplete
                      : AutodoLocalizations.markAllComplete,
                ),
              ),
              PopupMenuItem<ExtraAction>(
                value: ExtraAction.clearCompleted,
                child: Text(
                  AutodoLocalizations.clearCompleted,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}