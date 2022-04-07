import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/espera/bloc/eperando_bloc.dart';

import '../mio/bloc/contenido_bloc.dart';
import 'bloc/aniadir_bloc.dart';

class AddForm extends StatefulWidget {
  AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  var _titleC = TextEditingController();
  bool _defSwVal = false;
  File? image;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AniadirBloc, AniadirState>(
      listener: (context, state) {
        if(state is AniadirSuccess){
          _titleC.clear();
          _defSwVal = false;
          image = null;
          BlocProvider.of<ContenidoBloc>(context).add(ContenidoGetEvent());
          BlocProvider.of<EperandoBloc>(context).add(GetEsperaEvent());
        }if(state is AniadirFoto){
          image = state.image;
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              image != null
                  ? Image.file(
                      image!,
                      height: 120,
                    )
                  : Container(
                      height: 120,
                      color: Colors.grey,
                    ),
              SizedBox(
                height: 24,
              ),
              MaterialButton(
                onPressed: () {
                  BlocProvider.of<AniadirBloc>(context).add(AniadirImagenEvent());
                },
                child: Text("Añadir una Foto"),
                color: Colors.purple[200],
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _titleC,
                decoration: InputDecoration(
                  label: Text("Título"),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              SwitchListTile(
                  value: _defSwVal,
                  title: Text("Pública"),
                  onChanged: (v) => setState(() => _defSwVal = v)
              ),
              SizedBox(
                height: 24,
              ),
              MaterialButton(
                onPressed: () {
                  Map<String, dynamic> datos = {
                    "title": _titleC.value.text,
                    "public": _defSwVal
                  };
                  BlocProvider.of<AniadirBloc>(context).add(AniadirGuardarEvent(data: datos));
                },
                child: Text("Guardar"),
                color: Colors.purple[200],
              ),
            ],
          ),
        );
      },
    );
  }
}
