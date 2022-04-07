import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:foto_share/content/mio/bloc/contenido_bloc.dart';

class MiContenido extends StatefulWidget {
  MiContenido({Key? key}) : super(key: key);

  @override
  State<MiContenido> createState() => _MiContenidoState();
}

class _MiContenidoState extends State<MiContenido> {
  Map<String, dynamic>? document;
  var _titleC = TextEditingController();
  bool _defSwVal = false;
  File? image;
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContenidoBloc, ContenidoState>(
      listener: (context, state) {
        if(state is ContenidoFotoSuccess)
          this.image = state.image;
      },
      builder: (context, state) {
        if(state is ContenidoInitial){
          BlocProvider.of<ContenidoBloc>(context).add(ContenidoGetEvent());
          return ListView.builder(
            itemCount: 7,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return YoutubeShimmer();
            },
          );
        }
        if(state is ContenidoVacio)
          return Center(child: Text("Sin datos"),);
        if(state is ContenidoSuccess){
          double h = MediaQuery.of(context).size.height,
          w = MediaQuery.of(context).size.width;
          if(w>h){
            double t = w; w = h; h = t;
          }
          return ListView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                height: h * 0.41,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: state.datos.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return MiCItem(
                      document: state.datos[index], 
                      callback: (d){
                        this.document = d;
                        this._defSwVal = d["public"];
                        this.image = null;
                        _titleC.text = d["title"];
                        setState((){});
                      },
                    );
                  },
                ),
              ),
              Divider(),
              this.document != null? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(children: [
                  ListTile(title: Text("Editar"), trailing: IconButton(onPressed: ()=>setState(()=>this.document = null), icon: Icon(Icons.cancel)), ),
                  AspectRatio(
                    aspectRatio: 16/8,
                    child: this.image == null ? Image.network(this.document!["picture"], width: 64,) : Image.file(this.image!)
                  ),
                  SizedBox(height: 24,),
                  MaterialButton(
                    onPressed: () {
                      BlocProvider.of<ContenidoBloc>(context).add(ContenidoAddImageEvent(data: state.datos));
                    },
                    child: Text("Cambiar Foto"),
                    color: Colors.purple[200],
                  ),
                  SizedBox(height: 24,),
                  TextField(
                    controller: _titleC,
                    decoration: InputDecoration(
                      label: Text("Título"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24,),
                  SwitchListTile(
                      value: _defSwVal,
                      title: Text("Pública"),
                      onChanged: (v) => setState(() => _defSwVal = v)
                  ),
                  MaterialButton(
                    onPressed: () {
                      Map<String, dynamic> datos = {
                        "title": _titleC.value.text,
                        "public": _defSwVal,
                        "docId": this.document!["docId"],
                        "hasImage": this.image != null
                      };
                      print(this.document);
                      BlocProvider.of<ContenidoBloc>(context).add(ContenidoEditEvent(data: datos, prevData: state.datos));
                      this.document = null;
                    },
                    child: Text("Guardar"),
                    color: Colors.purple[200],
                  ),
                  SizedBox(height: 24,),
                ],),
              ) : Container(),
            ],
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

class MiCItem extends StatefulWidget {
  final Map<String, dynamic> document;
  final Function(Map<String, dynamic>) callback;

  MiCItem({Key? key, required this.document, required this.callback}) : super(key: key);

  @override
  State<MiCItem> createState() => _MiCItemState();
}

class _MiCItemState extends State<MiCItem> {
  bool _swVal = false;

  @override
  void initState() {
    super.initState();
    _swVal = widget.document["public"];
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height,
    w = MediaQuery.of(context).size.width;
    if(w>h){
      double t = w;
      w = h;
      h = t;
    }
    return Container(
      height: h * 0.3,
      width: w * 0.6,
      child: Card(
        child: Column(children: [
          AspectRatio(
            child: Image.network(widget.document["picture"], fit: BoxFit.cover,),
            aspectRatio: 16/9,
          ),
          Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              ListTile(
                title: Text("${widget.document["title"]}"),
                subtitle: Text("${widget.document["publishedAt"].toDate()}"),
                leading: CircleAvatar(foregroundImage: NetworkImage("${widget.document["pfp"]}"), maxRadius: 14,),
                minLeadingWidth: 16,
                visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.max, children: [
                SizedBox(
                  width: 40,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(value: _swVal, onChanged: (v){
                      setState(()=>_swVal=v);
                    }),
                  ),
                ),
              ],),
              SizedBox(
                height: 65,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.max, children: [
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.favorite, size: 16,),
                      constraints: BoxConstraints.tight(Size(40, 50)),
                    )
                ],),
              )
            ]
          ),
          MaterialButton(
            onPressed: (){
              //BlocProvider.of<ContenidoBloc>(context).add(EditContenidoEvent(data: widget.document["docId"]));
              widget.callback(widget.document);
            },
            child: Text("Editar"),
            color: Colors.purple[200],
          ),
        ],),
      )
    );
  }
}
