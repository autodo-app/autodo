import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/authentication_bloc/bloc.dart';
import 'package:autodo/blocs/user_repository.dart';
import 'package:autodo/blocs/todos/barrel.dart';
import 'delegate.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';
import 'screens/home/provider.dart';
import 'repositories/barrel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp.configure(
    name: 'autodo',
    options: FirebaseOptions(
      googleAppID: '1:617460744396:android:400cbb86de167047',
      projectID: 'autodo-49f21',
      apiKey: 'AIzaSyAAYhwsJVyiYywUFORBgaUuyXqXFiFpbZo',
    )
  );
  BlocSupervisor.delegate = AutodoBlocDelegate();
  final UserRepository userRepository = UserRepository();
  createTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(  
          create: (context) => AuthenticationBloc(
            userRepository: userRepository
          )..add(AppStarted()),
        ),
        BlocProvider<TodosBloc>(  
          create: (context) => TodosBloc(
            todosRepository: FirebaseDataRepository(),
          )..add(LoadTodos()),
        ),
      ],
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AutodoRoutes.home: (context) => HomeScreenProvider(),
        AutodoRoutes.welcome: (context) => MultiBlocProvider(  
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                userRepository: _userRepository
              ),
            )
          ],
          child: WelcomeScreen(
            userRepository: _userRepository,
          ),
        ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// class TodosApp extends StatelessWidget {
//   final UserRepository userRepository = UserRepository();

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthenticationBloc>(
//           create: (context) {
//             return AuthenticationBloc(userRepository: userRepository)
//               ..add(AppStarted());
//           },
//         ),
//         BlocProvider<TodosBloc>(
//           create: (context) {
//             return TodosBloc(
//               todosRepository: FirebaseTodosRepository(),
//             )..add(LoadTodos());
//           },
//         )
//       ],
//       child: MaterialApp(
//         title: 'auToDo',
//         routes: {
//           '/': (context) {
//             return BlocBuilder<AuthenticationBloc, AuthenticationState>(
//               builder: (context, state) {
//                 if (state is Authenticated) {
//                   return HomeScreenProvider();
//                 } else if (state is Unauthenticated) {
//                   return Center(
//                     child: Text('Could not authenticate with Firestore'),
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             );
//           },
//         },
//       ),
//     );
//   }
// }