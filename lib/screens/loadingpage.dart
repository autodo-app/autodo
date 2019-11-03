import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:autodo/blocs/init.dart';
import 'package:autodo/theme.dart';

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
      Navigator.pushNamed(context, '/welcomepage');
    } else {
      await initBLoCs(uuid);
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(  
      color: splashColor,
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
