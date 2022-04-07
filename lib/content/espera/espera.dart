import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:foto_share/content/espera/bloc/eperando_bloc.dart';

class Espera extends StatefulWidget {
  Espera({Key? key}) : super(key: key);

  @override
  State<Espera> createState() => _EsperaState();
}

class _EsperaState extends State<Espera> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EperandoBloc, EperandoState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if(state is EperandoCarga){
          return ListView.builder(
            itemCount: 14,
            itemBuilder: (BuildContext context, int index) {
              return YoutubeShimmer();
            },
          );
        }else if(state is EperandoVacio){
          return Center(child: Text("Sin datos"),);
        }else if(state is EperandoSuccess){
          return ListView.builder(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: state.datos.length,
            itemBuilder: (BuildContext context, int index) {
              return EperaItem(document: state.datos[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}



class EperaItem extends StatefulWidget {
  final Map<String, dynamic> document;

  EperaItem({Key? key, required this.document}) : super(key: key);

  @override
  State<EperaItem> createState() => _EperaItemState();
}

class _EperaItemState extends State<EperaItem> {
  bool _swVal = false;

  @override
  void initState() {
    super.initState();
    _swVal = widget.document["public"];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        AspectRatio(
          child: Image.network(widget.document["picture"], fit: BoxFit.cover,),
          aspectRatio: 16/9,
        ),
        SwitchListTile(
          title: Text("${widget.document["title"]}"), 
          subtitle: Text("${widget.document["publishedAt"].toDate()}"),
          onChanged: (bool val) {
            setState(() {
              _swVal = val;
            });
          }, 
          value: _swVal,
        ),
      ],),
    );
  }
}
