import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../../widgets/widgets.dart';
import '../widgets/barrel.dart';

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
