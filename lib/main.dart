import 'package:autodo/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autodo/blocs/barrel.dart';
import 'delegate.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';
import 'screens/home/provider.dart';
import 'screens/authentication/provider.dart';
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
  final AuthRepository authRepository = FirebaseAuthRepository();
  // ThemeData theme = AutodoTheme();
  ThemeData theme = createTheme();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
          userRepository: authRepository
        )..add(AppStarted()),
      child: BlocProvider<DatabaseBloc>(  
        create: (context) => DatabaseBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        )..add(LoadDatabase()),
        child: App(theme: theme),
      ),
    ),
  );
}

class App extends StatelessWidget {
  final ThemeData _theme;

  App({@required theme}) : assert(theme != null), _theme = theme;

  @override
  build(context) => MaterialApp(
    title: 'auToDo',
    routes: {
      "/": (context) => BlocBuilder<AuthenticationBloc, AuthenticationState>( 
        // Just here as the splitter between home screen and login screen
        builder: (context, state) {
          if (state is Authenticated) {
            Navigator.popAndPushNamed(context, AutodoRoutes.home);
            return Container();
          } else if (state is Unauthenticated) {
            Navigator.popAndPushNamed(context, AutodoRoutes.welcome);
            return Container();
          } else {
            return LoadingIndicator();
          }
        },
        bloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      AutodoRoutes.home: (context) => HomeScreenProvider(),
      AutodoRoutes.welcome: (context) => WelcomeScreenProvider(),
    },
    theme: _theme,
    debugShowCheckedModeBanner: false,
  );
}