import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'aniadir_event.dart';
part 'aniadir_state.dart';

class AniadirBloc extends Bloc<AniadirEvent, AniadirState> {
  File? selectedImage;

  AniadirBloc() : super(AniadirInitial()) {
    on<AniadirImagenEvent>(imagenAniadida);
    on<AniadirGuardarEvent>(guardarAniadida);
  }

  FutureOr<void> imagenAniadida(event, emit) async{
    emit(AniadirCargando());
    await _getImage();
    if(selectedImage == null) {
      emit(AniadirFotoError());
      return;
    }
    emit(AniadirFoto(image: selectedImage!));
  }

  FutureOr<void> guardarAniadida(AniadirGuardarEvent event, emit) async{
    emit(AniadirCargando());
    bool saved = await _savePhotoShare(event.data);
    emit(saved? AniadirSuccess(): AniadirError());
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

  Future<bool> _savePhotoShare(Map<String, dynamic> data) async{
    try {
      String url = await _upload();
      print(url);
      if(url.isEmpty) return false;
      data["picture"] = url;
      data["publishedAt"] = Timestamp.now();
      data["stars"]=0;
      data["username"]=FirebaseAuth.instance.currentUser!.displayName;

      var docRef = await FirebaseFirestore.instance.collection("photo_share").add(data);
      return await _updateUserDoc(docRef.id);
    } catch (e) {
      print("Error guardando: "+e.toString());
    }
    return false;
  }

  Future<bool> _updateUserDoc(String id) async{
    try {
      var user = await FirebaseFirestore.instance.collection("user").doc("${FirebaseAuth.instance.currentUser!.uid}");
      List<dynamic> photos = (await user.get()).data()?["photosListId"];
      photos.add(id);
      await user.update({"photosListId": photos});
      return true;
    } catch (e) {
      print("Error actualizando: "+e.toString());
    }
    return false;
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
