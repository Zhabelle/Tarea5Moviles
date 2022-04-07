part of 'eperando_bloc.dart';

abstract class EperandoEvent extends Equatable {
  const EperandoEvent();

  @override
  List<Object> get props => [];
}

class GetEsperaEvent extends EperandoEvent {}
