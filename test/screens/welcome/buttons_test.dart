import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/screens/welcome/widgets/buttons/barrel.dart';

import 'views/login_test.dart';

void main() {
  group('welcome widgets', () {
    testWidgets('google signin', (tester) async {
      final loginBloc = MockLoginBloc();
      bool pressed = false;
      when(loginBloc.add(LoginWithGooglePressed())).thenAnswer((_) {
        pressed = true;
      });
      await tester.pumpWidget(BlocProvider<LoginBloc>(
          create: (context) => loginBloc,
          child: Directionality(
              textDirection: TextDirection.ltr, child: GoogleLoginButton())));
      expect(find.byType(GoogleLoginButton), findsOneWidget);
      await tester.tap(find.byType(GoogleLoginButton));
      await tester.pump();
      expect(pressed, true);
    });
    testWidgets('password reset', (tester) async {
      final loginBloc = MockLoginBloc();
      when(loginBloc.state).thenReturn(LoginCredentialsValid(email: ''));
      await tester.pumpWidget(BlocProvider<LoginBloc>(
          create: (context) => loginBloc,
          child: MaterialApp(
              home: PasswordResetButton(dialogKey: ValueKey('dialogKey')))));
      expect(find.byType(PasswordResetButton), findsOneWidget);
      await tester.tap(find.byType(PasswordResetButton));
      await tester.pump();
      expect(find.byKey(ValueKey('dialogKey')), findsOneWidget);
    });
  });
}
