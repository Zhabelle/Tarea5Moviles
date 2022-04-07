part of 'eperando_bloc.dart';

abstract class EperandoState extends Equatable {
  const EperandoState();
  
  @override
  List<Object> get props => [];
}

class EperandoInitial extends EperandoState {}
class EperandoSuccess extends EperandoState {
  final List<Map<String, dynamic>> datos;

  EperandoSuccess({required this.datos});
  @override
  List<Object> get props => [this.datos];
}
class EperandoError extends EperandoState {}
class EperandoVacio extends EperandoState {}
class EperandoCarga extends EperandoState {}
