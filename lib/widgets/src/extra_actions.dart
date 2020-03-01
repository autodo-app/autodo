import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/localization.dart';
import 'package:json_intl/json_intl.dart';

class ExtraActions extends StatelessWidget {
  const ExtraActions(
      {Key key = const ValueKey('__extra_actions__'), this.toggleAllKey})
      : super(key: key);

  final Key toggleAllKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (context, state) {
        if (state is FilteredTodosLoaded) {
          final allComplete =
              (BlocProvider.of<TodosBloc>(context).state as TodosLoaded)
                  .todos
                  .every((todo) => todo.completed);
          final filterState = (BlocProvider.of<FilteredTodosBloc>(context).state
                  as FilteredTodosLoaded)
              .activeFilter;
          return PopupMenuButton<ExtraAction>(
            onSelected: (action) {
              switch (action) {
                case ExtraAction.toggleAllComplete:
                  BlocProvider.of<TodosBloc>(context).add(ToggleAll());
                  break;
                case ExtraAction.toggleFilter:
                  final nextFilter = (filterState == VisibilityFilter.all)
                      ? VisibilityFilter.active
                      : VisibilityFilter.all;
                  BlocProvider.of<FilteredTodosBloc>(context)
                      .add(UpdateTodosFilter(nextFilter));
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
              PopupMenuItem<ExtraAction>(
                key: toggleAllKey,
                value: ExtraAction.toggleAllComplete,
                child: Text(
                  allComplete
                      ? JsonIntl.of(context).get(IntlKeys.markAllIncomplete)
                      : JsonIntl.of(context).get(IntlKeys.markAllComplete),
                ),
              ),
              PopupMenuItem<ExtraAction>(
                key: ValueKey('__filter_button__'),
                value: ExtraAction.toggleFilter,
                child: Text((filterState == VisibilityFilter.all)
                    ? JsonIntl.of(context).get(IntlKeys.onlyShowActiveTodos)
                    : JsonIntl.of(context).get(IntlKeys.showAllTodos)),
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}
