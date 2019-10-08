import 'package:autodo/refueling/history.dart';
import 'package:autodo/screens/editrepeats.dart';
import 'package:autodo/screens/newuser.dart';
import 'package:autodo/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:autodo/screens/screens.dart';
import 'package:autodo/theme.dart';

class AutodoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AutodoAppState();
  }
}

class AutodoAppState extends State<AutodoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: '/load',
      title: 'auToDo',
      routes: {
        // '/': (context) => HomeScreen(),
        '/': (context) => NewUserScreen(),
        '/refuelinghistory': (context) => RefuelingHistory(),
        '/load': (context) => LoadingPage(),
        '/welcomepage': (context) => LoginPage(),
        '/loginpage': (context) => SignInScreen(
              formMode: FormMode.LOGIN,
            ),
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
