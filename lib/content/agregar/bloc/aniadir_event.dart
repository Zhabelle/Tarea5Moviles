part of 'aniadir_bloc.dart';

abstract class AniadirEvent extends Equatable {
  const AniadirEvent();

  @override
  List<Object> get props => [];
}

class AniadirImagenEvent extends AniadirEvent{}
class AniadirGuardarEvent extends AniadirEvent{
  final Map<String, dynamic> data;

  AniadirGuardarEvent({required this.data});

  @override
  List<Object> get props => [this.data];
}
