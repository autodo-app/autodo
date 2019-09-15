import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:autodo/blocs/userauth.dart';

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
    print(uuid);
    if (uuid == "NO_USER")
      Navigator.pushNamed(context, '/loginpage');
    else
      Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
