import 'package:autodo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import '../widgets/barrel.dart';

class RepeatsScreen extends StatelessWidget {
  const RepeatsScreen({
    Key key = const ValueKey('__repeats_screen__'),
  }) : super(key: key);

  @override
  Widget build(context) => BlocBuilder<RepeatsBloc, RepeatsState>(
        builder: (context, state) {
          if (state is RepeatsLoaded) {
            return ListView.builder(
              key: ValueKey('__repeats_screen_scroller__'),
              itemCount: state.repeats.length,
              itemBuilder: (context, index) {
                final repeat = state.sorted()[index];
                return Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: RepeatCard(repeat: repeat));
              },
            );
          } else {
            return LoadingIndicator();
          }
        },
      );
}
