import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../redux/redux.dart';
import 'latestcompleted.dart';
import 'mileage.dart';
import 'setrepeats.dart';
import 'wizard.dart';
import 'wizard_info.dart';

class NewUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreBuilder(
        builder: (BuildContext context, Store<AppState> store) =>
            Wizard<NewUserScreenWizard>(
          builder: (context, state) => NewUserScreenWizard(state, store),
          children: [
            MileageScreen(),
            LatestRepeatsScreen(),
            SetRepeatsScreen(),
          ],
        ),
      );
}
