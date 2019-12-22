import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';

import 'screen.dart';

class WelcomeScreenProvider extends StatelessWidget {
  @override
  build(context) => MultiBlocProvider(  
    providers: [

    ],
    child: WelcomeScreen(),
  );
}