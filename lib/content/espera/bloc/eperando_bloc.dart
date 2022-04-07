import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'eperando_event.dart';
part 'eperando_state.dart';

class EperandoBloc extends Bloc<EperandoEvent, EperandoState> {
  EperandoBloc() : super(EperandoInitial()) {
    on<GetEsperaEvent>(getContent);
  }

  FutureOr<void> getContent(event, emit) async {
    emit(EperandoCarga());
    try {
      var user = await FirebaseFirestore.instance.collection("user").doc("${FirebaseAuth.instance.currentUser!.uid}").get();
      var photos = user.data()?["photosListId"];
      var allDocs = await FirebaseFirestore.instance.collection("photo_share").get();
      List<Map<String, dynamic>> data = allDocs.docs.where((doc) => !doc.data()["public"] && (photos as List).contains(doc.id)).map((e) => e.data()).toList();
      emit(EperandoSuccess(datos: data));
    } catch (e) {
      emit(EperandoError());
      print("Se meó en mi cara");
      print(e);
      emit(EperandoVacio());
    }
  }
}
