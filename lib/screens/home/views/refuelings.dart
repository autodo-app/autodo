import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/screens/details/barrel.dart';
import '../widgets/barrel.dart';

class RefuelingsScreen extends StatelessWidget {
  RefuelingsScreen({Key key}) : super(key: key);

  onDismissed(direction, context, refueling) {
    BlocProvider.of<RefuelingsBloc>(context).add(DeleteRefueling(refueling));
    Scaffold.of(context).showSnackBar(
      DeleteRefuelingSnackBar(
        onUndo: () => BlocProvider.of<RefuelingsBloc>(context)
          .add(AddRefueling(refueling)),
      )
    );
  }

  onTap(context, refueling) async {
    final removedRefueling = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailsScreen(id: refueling.id),
      ),
    );
    if (removedRefueling != null) {
      Scaffold.of(context).showSnackBar(
      DeleteRefuelingSnackBar(
        onUndo: () => BlocProvider.of<RefuelingsBloc>(context)
          .add(AddRefueling(refueling)),
      )
    );
    }
  }

  @override 
  build(context) => 
      BlocBuilder<FilteredRefuelingsBloc, FilteredRefuelingsState>(  
    builder: (context, state) {
      if (state is FilteredRefuelingsLoading) {
        return LoadingIndicator();
      } else if (state is FilteredRefuelingsLoaded) {
        final refuelings = state.filteredRefuelings;
        return ListView.builder(   
          itemCount: refuelings.length,
          itemBuilder: (context, index) {
            final refueling = refuelings[index];
            return Padding(  
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: RefuelingCard(  
                refueling: refueling,
                onDismissed: (direction) =>
                    onDismissed(direction, context, refueling),
                onTap: () => onTap(context, refueling)
              ),
            );
          }
        );
      } else {
        return Container();
      }
    }
  );
}