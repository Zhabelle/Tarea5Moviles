part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AnonAuthEvent extends AuthEvent{}
class GoogleAuthEvent extends AuthEvent{}
class VerifyAuthEvent extends AuthEvent{}
class RemoveAuthEvent extends AuthEvent{}
