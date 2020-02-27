import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:autodo/widgets/widgets.dart';
import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/integ_test_keys.dart';
import 'package:autodo/theme.dart';
import 'mileage.dart';
import 'latestcompleted.dart';
import 'setrepeats.dart';
import 'new_user_screen_page.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key key = IntegrationTestKeys.newUserScreen})
      : super(key: key);

  @override
  NewUserScreenState createState() => NewUserScreenState();
}

class NewUserScreenState extends State<NewUserScreen> {
  final page = ValueNotifier<NewUserScreenPage>(NewUserScreenPage.MILEAGE);
  final mileageKey = GlobalKey<FormState>();
  final latestKey = GlobalKey<FormState>();
  final repeatsKey = GlobalKey<FormState>();
  String mileageEntry = '';

  void mileageOnNext() {
    setState(() => page.value = NewUserScreenPage.LATEST);
  }

  void latestOnNext() {
    setState(() => page.value = NewUserScreenPage.REPEATS);
  }

  Widget currentPage() {
    if (page.value == NewUserScreenPage.MILEAGE) {
      return ValueListenableBuilder(
        valueListenable: page,
        builder: (BuildContext context, NewUserScreenPage val, Widget child) {
          return MileageScreen(mileageEntry, mileageKey, mileageOnNext);
        },
      );
    } else if (page.value == NewUserScreenPage.LATEST) {
      return ValueListenableBuilder(
        valueListenable: page,
        builder: (BuildContext context, NewUserScreenPage val, Widget child) {
          return LatestRepeatsScreen(latestKey, latestOnNext, val);
        },
      );
    } else if (page.value == NewUserScreenPage.REPEATS) {
      return ValueListenableBuilder(
        valueListenable: page,
        builder: (BuildContext context, NewUserScreenPage val, Widget child) {
          return SetRepeatsScreen(repeatsKey, val);
        },
      );
    } else {
      return Container();
    }
  }

  void backAction() {
    if (page.value == NewUserScreenPage.MILEAGE) {
      // delete the current user somehow?
      Navigator.pop(context);
    } else if (page.value == NewUserScreenPage.LATEST) {
      setState(() => page.value = NewUserScreenPage.MILEAGE);
    } else if (page.value == NewUserScreenPage.REPEATS) {
      setState(() => page.value = NewUserScreenPage.LATEST);
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) =>
              BlocBuilder<DatabaseBloc, DatabaseState>(
                  builder: (context, dbState) {
                print('auth $authState db $dbState');
                if ((authState is RemoteAuthenticated ||
                        authState is LocalAuthenticated) &&
                    dbState is DbLoaded) {
                  return Container(
                    decoration: scaffoldBackgroundGradient(),
                    child: Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => backAction(),
                        ),
                      ),
                      body: currentPage(),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                } else {
                  return LoadingIndicator();
                }
              }));
}
