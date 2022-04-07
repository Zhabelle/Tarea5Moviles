import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foto_share/content/agregar/add_form.dart';
import 'package:foto_share/content/agregar/bloc/aniadir_bloc.dart';
import 'package:foto_share/content/espera/bloc/eperando_bloc.dart';
import 'package:foto_share/content/espera/espera.dart';
import 'package:foto_share/content/mio/bloc/contenido_bloc.dart';
import 'package:foto_share/content/mio/mi_content.dart';
import 'package:foto_share/content/pati/pati.dart';
import 'package:foto_share/login/bloc/auth_bloc.dart';
import 'package:foto_share/login/loginPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc()..add(VerifyAuthEvent()),
      ),
      BlocProvider(create: (context) => EperandoBloc()..add(GetEsperaEvent()),),
      BlocProvider(create: (context) => ContenidoBloc(),),
      BlocProvider(create: (context) => AniadirBloc(),),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO:
        },
        builder: (context, state) {
          if (state is AuthSuccess) return HomePage();
          if (state is AuthError) return LoginPage();
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currIndex = 0;
  final _pageNames = ["Para Tí", "Sin Publicar", "Agregar", "Mi contenido"];
  final _pageList = <Widget>[
    Fotazas(),
    Espera(),
    AddForm(),
    MiContenido(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageNames[_currIndex]),
        flexibleSpace: Container(
          height: 120,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red, Colors.purple])),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currIndex,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currIndex,
        onTap: (value) {
          _currIndex = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            label: _pageNames[0],
            icon: Icon(Icons.view_carousel),
          ),
          BottomNavigationBarItem(
            label: _pageNames[1],
            icon: Icon(Icons.query_builder),
          ),
          BottomNavigationBarItem(
            label: _pageNames[2],
            icon: Icon(Icons.photo_camera),
          ),
          BottomNavigationBarItem(
            label: _pageNames[3],
            icon: Icon(Icons.mobile_friendly),
          ),
        ],
      ),
    );
  }
}
