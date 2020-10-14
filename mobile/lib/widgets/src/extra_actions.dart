import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:json_intl/json_intl.dart';

import '../../generated/localization.dart';
import '../../models/models.dart';
import '../../redux/redux.dart';

class ExtraActions extends StatelessWidget {
  const ExtraActions(
      {Key key = const ValueKey('__extra_actions__'), this.toggleAllKey})
      : super(key: key);

  final Key toggleAllKey;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) => PopupMenuButton<ExtraAction>(
          onSelected: (action) {
            vm.onActionSelected(action);
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<ExtraAction>>[
            PopupMenuItem<ExtraAction>(
              key: toggleAllKey,
              value: ExtraAction.toggleAllComplete,
              child: Text(
                vm.allComplete
                    ? JsonIntl.of(context).get(IntlKeys.markAllIncomplete)
                    : JsonIntl.of(context).get(IntlKeys.markAllComplete),
              ),
            ),
            PopupMenuItem<ExtraAction>(
              key: ValueKey('__filter_button__'),
              value: ExtraAction.toggleFilter,
              child: Text((vm.filterState == VisibilityFilter.all)
                  ? JsonIntl.of(context).get(IntlKeys.onlyShowActiveTodos)
                  : JsonIntl.of(context).get(IntlKeys.showAllTodos)),
            )
          ],
        ),
      );
}

class _ViewModel extends Equatable {
  const _ViewModel(
      {@required this.onActionSelected,
      @required this.allComplete,
      @required this.filterState});

  final Function(ExtraAction) onActionSelected;
  final bool allComplete;
  final VisibilityFilter filterState;

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
      onActionSelected: (action) {
        if (action == ExtraAction.toggleAllComplete) {
          // store.dispatch(ToggleAllTodosComplete()); // TODO
        } else if (action == ExtraAction.toggleFilter) {
          // TODO
          // store.dispatch(UpdateTodosFilter(
          //     (store.state.filterState.todosFilter == VisibilityFilter.all)
          //         ? VisibilityFilter.active
          //         : VisibilityFilter.all));
        }
      },
      filterState: store.state.filterState.todosFilter,
      allComplete: store.state.dataState.todos
          .every((t) => t.completedOdomSnapshot != null));

  @override
  List get props => [onActionSelected, allComplete];
}
