import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/telas/Especialidades.dart';
import 'package:med_quest_adm/telas/Membros.dart';
import 'package:med_quest_adm/telas/Perguntas.dart';
import 'package:med_quest_adm/telas/Planos.dart';
import 'package:med_quest_adm/telas/Temas.dart';
import '../main.dart';
import 'ListaResultadoUsuario.dart';
import 'Login.dart';
import 'Simulados.dart';

class Principal extends StatefulWidget {

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  String _idUsuarioLogado;
  String _email;
  List<String> itensMenu = ["Sair"];

  _escolhaMenuItem(String itemEscolhido){

    switch (itemEscolhido){
      case "Sair":
        _deslogarUsuario();
        break;
    }
  }

  _recuperarDadosADM()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await
    db.collection("usuariosAdm")
        .document(_idUsuarioLogado)
        .get();

    Map<String,dynamic> dados = snapshot.data;
    setState(() {
      _email = dados["email"].toString();
      print("usuario : "+_email);
    });
  }

  _deslogarUsuario()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosADM();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: temaPadrao.primaryColor,
        title: Image.asset(
          "assets/imagens/logoOficial.png",
          alignment: Alignment.center,
          width: 450,
          height: 150,
        ),
          actions: <Widget>[
            PopupMenuButton<String>(
            icon: Icon(Icons.view_headline,color: Colors.white),
            onSelected: _escolhaMenuItem,
                itemBuilder: (context){
                  return itensMenu.map((String item) {
                    return PopupMenuItem<String>(
                        value: item,
                        child: Text(item));
                  }).toList();
                }
            )
          ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 5),
                child: Text("Gerenciar",
                    style: TextStyle(fontSize: 25,
                        color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: RaisedButton(
                    child: Text(
                      "Especialidades",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Especialidades()
                          )
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                    child: Text(
                      "Temas",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Temas()
                          )
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                    child: Text(
                      "Perguntas",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Perguntas()
                          )
                      );
                    }),
              ),
              _email == "bruno.yuki@gmail.com"?
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                    child: Text(
                      "Usuários",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Membros()
                          )
                      );
                    }),
              ):Container(),
              _email == "bruno.yuki@gmail.com"?
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                    child: Text(
                      "Planos",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Planos()
                          )
                      );
                    }),
              ):Container(),
              _email == "bruno.yuki@gmail.com"?
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                    child: Text(
                      "Simulado",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Simulados()
                          )
                      );
                    }),
              ):Container(),
              _email == "bruno.yuki@gmail.com"?
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                    child: Text(
                      "Resultados",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListaResultadoUsuario()
                          )
                      );
                    }),
              ):Container()
            ],
          ),
        ),
      ),
    );
  }
}
