import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/auth/authbloc.dart';
import 'package:todo/bloc/auth/authevent.dart';
import 'package:todo/bloc/login/loginbloc.dart';
import 'package:todo/bloc/login/loginevent.dart';
import 'package:todo/bloc/login/loginstate.dart';
import 'package:todo/models/firebase/user_repo.dart';

class LoginPage extends StatelessWidget {
  final UserRepository _userRepository;

  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginSubPage(),
      ),
    );
  }
}

class LoginSubPage extends StatelessWidget {
  // final UserRepository _userRepository;

  // LoginSubPage({Key key, @required UserRepository userRepository})
  //     : assert(userRepository != null),
  //       _userRepository = userRepository,
  //       super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state == LoginSuccess()) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
        }
      },
      child: Center(
        child: OutlineButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () =>
              BlocProvider.of<LoginBloc>(context).add(LoginWithGoogle()),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/google.png',
                  height: 50,
                  width: 50,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Sign In with Google',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
