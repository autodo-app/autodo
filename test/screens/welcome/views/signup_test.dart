import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/screens/welcome/views/signup/screen.dart';
import 'package:autodo/screens/welcome/widgets/barrel.dart';
import 'package:autodo/blocs/blocs.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSignupBloc extends MockBloc<SignupEvent, SignupState>
    implements SignupBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  group('SignupScreen', () {
    AuthRepository authRepository;
    SignupBloc signupBloc;
    AuthenticationBloc authBloc;

    setUp(() {
      authRepository = MockAuthRepository();
      signupBloc = MockSignupBloc();
      authBloc = MockAuthenticationBloc();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SignupBloc>.value(
                value: SignupBloc(authRepository: authRepository)),
          ],
          child: MaterialApp(home: SignupScreen(key: scaffoldKey)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(scaffoldKey), findsOneWidget);
    });
    testWidgets('back button', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SignupBloc>.value(
                value: SignupBloc(authRepository: authRepository)),
          ],
          child: MaterialApp(home: SignupScreen(key: scaffoldKey)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(find.byKey(scaffoldKey), findsOneWidget);
    });
    testWidgets('error', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      whenListen(signupBloc,
          Stream.fromIterable([SignupEmpty(), SignupError('test')]));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SignupBloc>.value(value: signupBloc),
          ],
          child: MaterialApp(home: SignupScreen(key: scaffoldKey)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });
    testWidgets('loading', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      whenListen(
          signupBloc, Stream.fromIterable([SignupEmpty(), SignupLoading()]));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<SignupBloc>.value(value: signupBloc),
          ],
          child: MaterialApp(home: SignupScreen(key: scaffoldKey)),
        ),
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
    testWidgets('signed in', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      whenListen(
          signupBloc, Stream.fromIterable([SignupEmpty(), SignupSuccess()]));
      when(authBloc.add(LoggedIn())).thenAnswer((_) => null);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(
              value: authBloc,
            ),
            BlocProvider<SignupBloc>.value(value: signupBloc),
          ],
          child: MaterialApp(home: SignupScreen(key: scaffoldKey), routes: {
            "__home__": (context) => Container(),
          }),
        ),
      );
      await tester.pumpAndSettle();
      verify(authBloc.add(LoggedIn())).called(1);
    });
    testWidgets('submit form', (WidgetTester tester) async {
      Key scaffoldKey = Key('scaffold');
      when(signupBloc.add(SignupWithCredentialsPressed(
              email: 'test@test.com', password: '123456')))
          .thenAnswer((_) => null);
      when(authBloc.add(LoggedIn())).thenAnswer((_) => null);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(
              value: authBloc,
            ),
            BlocProvider<SignupBloc>.value(value: signupBloc),
          ],
          child: MaterialApp(home: SignupScreen(key: scaffoldKey), routes: {
            "__home__": (context) => Container(),
          }),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EmailForm), 'test@test.com');
      await tester.enterText(find.byType(PasswordForm), '123456');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SignupSubmitButton));
      await tester.pump();
      verify(signupBloc.add(SignupWithCredentialsPressed(
              email: 'test@test.com', password: '123456')))
          .called(1);
    });
  });
}
