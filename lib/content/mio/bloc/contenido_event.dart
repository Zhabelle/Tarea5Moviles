part of 'contenido_bloc.dart';

abstract class ContenidoEvent extends Equatable {
  const ContenidoEvent();

  @override
  List<Object> get props => [];
}

class ContenidoGetEvent extends ContenidoEvent {}
class ContenidoAddImageEvent extends ContenidoEvent {
  final List<Map<String, dynamic>> data;

  ContenidoAddImageEvent({required this.data});

  @override
  List<Object> get props => [this.data];
}
class ContenidoEditEvent extends ContenidoEvent {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> prevData;

  ContenidoEditEvent({required this.data, required this.prevData});

  @override
  List<Object> get props => [this.data, this.prevData];
}
