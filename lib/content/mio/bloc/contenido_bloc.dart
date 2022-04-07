import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'contenido_event.dart';
part 'contenido_state.dart';

class ContenidoBloc extends Bloc<ContenidoEvent, ContenidoState> {
  File? selectedImage;

  ContenidoBloc() : super(ContenidoInitial()) {
    on<ContenidoGetEvent>(getContent);
    on<ContenidoEditEvent>(editContent);
    on<ContenidoAddImageEvent>(imagenAniadida);
  }

  FutureOr<void> getContent(event, emit) async{
    emit(ContenidoInitial());
    try {
      var user = await FirebaseFirestore.instance.collection("user").doc("${FirebaseAuth.instance.currentUser!.uid}").get();
      var photos = user.data()?["photosListId"];
      var allDocs = await FirebaseFirestore.instance.collection("photo_share").get();
      List<Map<String, dynamic>> data = allDocs.docs.where((doc) => (photos as List).contains(doc.id)).map((e) => e.data()..addAll({"pfp": FirebaseAuth.instance.currentUser!.photoURL, "docId": e.id})).toList();
      emit(ContenidoSuccess(datos: data));
    } catch (e) {
      emit(ContenidoError());
      print("Se meó en mi cara");
      print(e);
      emit(ContenidoVacio());
    }
  }

  FutureOr<void> editContent(ContenidoEditEvent event, emit) async{
    bool saved = await _savePhotoShare(event.data);
    emit(saved? ContenidoSuccess(datos: event.prevData): ContenidoError());
    emit(ContenidoInitial());
  }

  Future<bool> _savePhotoShare(Map<String, dynamic> data) async{
    try {
      if(data["hasImage"]){
        String url = await _upload();
        if(url.isEmpty) return false;
        data["picture"] = url;
      }
      data["publishedAt"] = Timestamp.now();
      String docId = data["docId"];
      data.remove("docId");

      await FirebaseFirestore.instance.collection("photo_share").doc(docId).update(data);
      return true;
    } catch (e) {
      print("Error guardando: "+e.toString());
    }
    return false;
  }

  FutureOr<void> imagenAniadida(ContenidoAddImageEvent event, Emitter<ContenidoState> emit) async{
    await _getImage();
    if(selectedImage == null) {
      emit(ContenidoFotoError());
      return;
    }
    emit(ContenidoFotoSuccess(image: selectedImage!));
    emit(ContenidoSuccess(datos: event.data));
  }

  Future<void> _getImage() async{
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
    } else {
      print('No image selected.');
      selectedImage = null;
    }
  }

  Future<String> _upload() async{
    try {
      if(selectedImage == null) return "";
      String name = "${DateTime.now().toString()}.${selectedImage!.path.split(".").last}";
      UploadTask task = FirebaseStorage.instance.ref().child("pics").child(name).putFile(selectedImage!);
      await task;
      return await task.storage.ref("pics/${name}").getDownloadURL();
    } catch (e) {
      return "";
    }
  }
}
