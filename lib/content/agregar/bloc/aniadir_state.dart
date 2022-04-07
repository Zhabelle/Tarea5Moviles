part of 'aniadir_bloc.dart';

abstract class AniadirState extends Equatable {
  const AniadirState();
  
  @override
  List<Object> get props => [];
}

class AniadirInitial extends AniadirState {}

class AniadirSuccess extends AniadirState {}
class AniadirError extends AniadirState {}
class AniadirCargando extends AniadirState {}
class AniadirFotoError extends AniadirState {}
class AniadirFoto extends AniadirState {
  final File image;

  AniadirFoto({required this.image});

  @override
  List<Object> get props => [this.image];
}
