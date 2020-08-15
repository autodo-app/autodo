import 'package:flutter/material.dart';

import 'latestcompleted.dart';
import 'mileage.dart';
import 'setrepeats.dart';
import 'wizard.dart';
import 'wizard_info.dart';

class NewUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wizard<NewUserScreenWizard>(
      builder: (context, state) => NewUserScreenWizard(state),
      children: [
        MileageScreen(),
        LatestRepeatsScreen(),
        SetRepeatsScreen(),
      ],
    );
  }
}
