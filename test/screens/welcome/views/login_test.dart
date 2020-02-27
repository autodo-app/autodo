import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/screens/welcome/views/login/screen.dart';
import 'package:autodo/screens/welcome/widgets/barrel.dart';
import 'package:autodo/blocs/blocs.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  group('WelcomeScreen', () {
    AuthRepository authRepository;
    LoginBloc loginBloc;
    AuthenticationBloc authBloc;

    setUp(() {
      authRepository = MockAuthRepository();
      loginBloc = MockLoginBloc();
      authBloc = MockAuthenticationBloc();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      final Key scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>.value(
                value: LoginBloc(authRepository: authRepository)),
          ],
          child: MaterialApp(home: LoginScreen(key: scaffoldKey)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(scaffoldKey), findsOneWidget);
    });
    testWidgets('back button', (WidgetTester tester) async {
      final Key scaffoldKey = Key('scaffold');
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>.value(
                value: LoginBloc(authRepository: authRepository)),
          ],
          child: MaterialApp(home: LoginScreen(key: scaffoldKey)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(find.byKey(scaffoldKey), findsOneWidget);
    });
    testWidgets('error', (WidgetTester tester) async {
      final Key scaffoldKey = Key('scaffold');
      whenListen(
          loginBloc, Stream.fromIterable([LoginEmpty(), LoginError('test')]));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>.value(value: loginBloc),
          ],
          child: MaterialApp(home: LoginScreen(key: scaffoldKey)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });
    testWidgets('loading', (WidgetTester tester) async {
      final Key scaffoldKey = Key('scaffold');
      whenListen(
          loginBloc, Stream.fromIterable([LoginEmpty(), LoginLoading()]));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>.value(value: loginBloc),
          ],
          child: MaterialApp(home: LoginScreen(key: scaffoldKey)),
        ),
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
    testWidgets('loggedin', (WidgetTester tester) async {
      final Key scaffoldKey = Key('scaffold');
      whenListen(
          loginBloc, Stream.fromIterable([LoginEmpty(), LoginSuccess()]));
      when(authBloc.add(LoggedIn())).thenAnswer((_) => null);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(
              value: authBloc,
            ),
            BlocProvider<LoginBloc>.value(value: loginBloc),
          ],
          child: MaterialApp(home: LoginScreen(key: scaffoldKey), routes: {
            "__home__": (context) => Container(),
          }),
        ),
      );
      await tester.pumpAndSettle();
      verify(authBloc.add(LoggedIn())).called(1);
    });
    testWidgets('submit form', (WidgetTester tester) async {
      final Key scaffoldKey = Key('scaffold');
      when(authBloc.add(LoggedIn())).thenAnswer((_) => null);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>.value(
              value: authBloc,
            ),
            BlocProvider<LoginBloc>.value(value: loginBloc),
          ],
          child: MaterialApp(home: LoginScreen(key: scaffoldKey), routes: {
            "__home__": (context) => Container(),
          }),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EmailForm), 'test@test.com');
      await tester.enterText(find.byType(PasswordForm), '123456');
      await tester.pump();
      await tester.tap(find.byType(LoginSubmitButton));
      await tester.pump();
      verify(loginBloc.add(LoginWithCredentialsPressed(
              email: 'test@test.com', password: '123456')))
          .called(1);
    });
  });
}
