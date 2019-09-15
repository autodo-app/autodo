import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:autodo/blocs/repeating.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    loadingSequence();
    super.initState();
  }

  Future<Null> loadingSequence() async {
    String uuid = await Auth().fetchUser();
    if (uuid == "NO_USER") {
      Navigator.pushNamed(context, '/loginpage');
    } else {
      await RepeatingBLoC().updateUpcomingTodos();
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
