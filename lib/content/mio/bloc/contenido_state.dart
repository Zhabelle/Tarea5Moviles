part of 'contenido_bloc.dart';

abstract class ContenidoState extends Equatable {
  const ContenidoState();
  
  @override
  List<Object> get props => [];
}

class ContenidoInitial extends ContenidoState {}
class ContenidoSuccess extends ContenidoState {
  final List<Map<String, dynamic>> datos;

  ContenidoSuccess({required this.datos});
  @override
  List<Object> get props => this.datos;
}
class ContenidoError extends ContenidoState {}
class ContenidoVacio extends ContenidoState {}

class ContenidoFotoError extends ContenidoState {}
class ContenidoFotoSuccess extends ContenidoState {
  final File image;

  ContenidoFotoSuccess({required this.image});
  @override
  List<Object> get props => [this.image];
}
