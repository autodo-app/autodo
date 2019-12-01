import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/screens/newusersetup/newusersetup.dart';

class NewUserScreen extends StatefulWidget {
  @override
  NewUserScreenState createState() => NewUserScreenState();
}

enum NewUserScreenPage { MILEAGE, LATEST, REPEATS }

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
    } else if (page.value == NewUserScreenPage.LATEST)
      setState(() => page.value = NewUserScreenPage.MILEAGE);
    else if (page.value == NewUserScreenPage.REPEATS)
      setState(() => page.value = NewUserScreenPage.LATEST);
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
