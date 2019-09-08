import 'package:autodo/refueling/history.dart';
import 'package:autodo/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:autodo/screens/screens.dart';

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
      // theme: ThemeData.dark(),
      title: 'auToDo',
      initialRoute: '/load',
      routes: {
        '/': (context) => HomeScreen(),
        '/refuelinghistory': (context) => RefuelingHistory(),
        '/load': (context) => LoadingPage(),
        '/welcomepage': (context) => LoginPage(),
        '/loginpage': (context) => SignInScreen(
              formMode: FormMode.LOGIN,
            ),
        '/signuppage': (context) => SignInScreen(formMode: FormMode.SIGNUP),
        '/createTodo': (context) => CreateTodoScreen(),
        '/createRefueling': (context) => CreateRefuelingScreen(),
        '/settings': (context) => SettingsScreen(),
        '/statistics': (context) => StatisticsScreen(),
        '/editcarlist': (context) => EditCarListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
