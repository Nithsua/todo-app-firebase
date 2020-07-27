import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/auth/authevent.dart';
import 'package:todo/bloc/auth/authstate.dart';
import 'package:todo/models/firebase/user_repo.dart';
import 'package:flutter/foundation.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      yield AuthenticationSuccess();
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess();
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    await _userRepository.signOut();
  }
}
