import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/login/loginevent.dart';
import 'package:todo/bloc/login/loginstate.dart';
import 'package:flutter/foundation.dart';
import 'package:todo/models/firebase/user_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithGoogle) {
      yield* _mapLoginWithGoogleToEvent();
    }
  }

  Stream<LoginState> _mapLoginWithGoogleToEvent() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginSuccess();
    } catch (_) {
      yield LoginFailure();
    }
  }
}
