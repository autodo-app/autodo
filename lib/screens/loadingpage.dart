import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:autodo/blocs/repeating.dart';
import 'package:autodo/blocs/firestore.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  LinearGradient blueGrey = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.blueGrey[200], Colors.blueGrey[800]],
  );
  LinearGradient blue = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.blue[300], Colors.blue[900]],
  );
  BoxDecoration bgGradient() {
    return BoxDecoration(
      gradient: LinearGradient.lerp(blueGrey, blue, 0.4),
    );
  }

  @override
  void initState() {
    loadingSequence();
    super.initState();
  }

  Future<Null> loadingSequence() async {
    String uuid = await Auth().fetchUser();
    FirestoreBLoC.fetchUserDocument();
    if (uuid == "NO_USER") {
      Navigator.pushNamed(context, '/loginpage');
    } else {
      await RepeatingBLoC().updateUpcomingTodos();
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: bgGradient(),
        ),
      ),
    );
  }
}
