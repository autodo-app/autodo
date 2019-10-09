import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/screens/newusersetup/newusersetup.dart';

class NewUserScreen extends StatefulWidget {
  @override
  NewUserScreenState createState() => NewUserScreenState();
}

enum NewUserScreenPage {
  MILEAGE,
  LATEST,
  REPEATS
}

class NewUserScreenState extends State<NewUserScreen> {
  NewUserScreenPage page = NewUserScreenPage.MILEAGE;
  final mileageKey = GlobalKey<FormState>();
  final latestKey = GlobalKey<FormState>();
  final repeatsKey = GlobalKey<FormState>();
  String mileageEntry = '';

  void mileageOnNext() => setState(() => page = NewUserScreenPage.LATEST);
  void latestOnNext() => setState(() => page = NewUserScreenPage.REPEATS);

  Widget currentPage() {
    if (page == NewUserScreenPage.MILEAGE)
      return MileageScreen(mileageEntry, mileageKey, mileageOnNext);
    else if (page == NewUserScreenPage.LATEST)
      return LatestRepeatsScreen(latestKey, latestOnNext);
    else if (page == NewUserScreenPage.REPEATS)
      return SetRepeatsScreen(repeatsKey);
    else 
      return Container();
  }

  void backAction() {
    if (page == NewUserScreenPage.MILEAGE)
      Navigator.pop(context);
    else if (page == NewUserScreenPage.LATEST)
      setState(() => page = NewUserScreenPage.MILEAGE);
    else if (page == NewUserScreenPage.REPEATS)
      setState(() => page = NewUserScreenPage.LATEST);
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