import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/auth/authbloc.dart';
import 'package:todo/bloc/auth/authevent.dart';
import 'package:todo/bloc/auth/authstate.dart';
import 'package:todo/models/firebase/user_repo.dart';
import 'package:todo/pages/homepage.dart';
import 'package:todo/pages/loginpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: MyApp(userRepository: userRepository),
    ),
  );
}

ThemeData lightTheme = ThemeData(
  unselectedWidgetColor: Colors.white,
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Colors.black,
  ),
  unselectedWidgetColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  cursorColor: Colors.white,
  accentColor: Colors.blueAccent,
  primaryTextTheme: TextTheme(
    bodyText2: TextStyle(
      color: Colors.white,
    ),
  ),
);

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      theme: lightTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            return HomePage();
          }
          return LoginPage(userRepository: _userRepository);
        },
      ),
    );
  }
}
