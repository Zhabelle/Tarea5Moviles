import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/login/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: ListView(
          children: [
            Center(child: Text("Sign in", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
            SizedBox(height: 20,),
            Container(
              width: 128.0,
              height: 128.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/icons/icon.png"),
                ),
              ),
            ),
            SizedBox(height: 160,),
            MaterialButton(
              onPressed: (){
                BlocProvider.of<AuthBloc>(context).add(AnonAuthEvent());
              },
              child: Text("Iniciar anónimamente", style: TextStyle(color: Colors.grey.shade100),),
              color: Colors.grey,
            ),
            Text("Or use one of your social profiles", textAlign: TextAlign.center,),
            MaterialButton(
              onPressed: (){
                BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
              },
              child: Text("Iniciar con Google", style: TextStyle(color: Colors.grey.shade100),),
              color: Colors.teal.shade400,
            ),
          ],
        ),
      ),
    );
  }
}