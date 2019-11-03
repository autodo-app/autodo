import 'package:autodo/refueling/history.dart';
import 'package:autodo/screens/editrepeats.dart';
import 'package:autodo/screens/newuser.dart';
import 'package:autodo/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:autodo/screens/screens.dart';
import 'package:autodo/theme.dart';
import 'package:firebase_core/firebase_core.dart';

class AutodoApp extends StatefulWidget {
  AutodoApp() {
    FirebaseApp.configure(
      name: 'autodo',
      options: FirebaseOptions(  
        googleAppID: '1:617460744396:android:400cbb86de167047',
        projectID: 'autodo-49f21',
        apiKey: 'AIzaSyAAYhwsJVyiYywUFORBgaUuyXqXFiFpbZo',
      )
    );
  }

  @override
  State<StatefulWidget> createState() => AutodoAppState();
}

class AutodoAppState extends State<AutodoApp> {
  @override
  Widget build(BuildContext context) {
    var theme = createTheme();
    return MaterialApp(
      theme: theme,
      initialRoute: '/load',
      title: 'auToDo',
      routes: {
        '/': (context) => HomeScreen(),
        '/refuelinghistory': (context) => RefuelingHistory(),
        '/load': (context) => LoadingPage(),
        '/welcomepage': (context) => LoginPage(),
        '/loginpage': (context) => SignInScreen(
              formMode: FormMode.LOGIN,
            ),
        '/newuser': (context) => NewUserScreen(),
        '/signuppage': (context) => SignInScreen(formMode: FormMode.SIGNUP),
        '/createTodo': (context) => CreateTodoScreen(mode: TodoEditMode.CREATE),
        '/createRefueling': (context) =>
            CreateRefuelingScreen(mode: RefuelingEditMode.CREATE),
        '/settings': (context) => SettingsScreen(),
        '/statistics': (context) => StatisticsScreen(),
        '/editcarlist': (context) => EditCarListScreen(),
        '/editrepeats': (context) => EditRepeatsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
