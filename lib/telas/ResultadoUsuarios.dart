import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/UsuarioModel.dart';
import '../main.dart';

class ResultadoUsuarios extends StatefulWidget {

  UsuarioModel usuario;
  ResultadoUsuarios(this.usuario);

  @override
  _ResultadoUsuariosState createState() => _ResultadoUsuariosState();
}

class _ResultadoUsuariosState extends State<ResultadoUsuarios> {

  UsuarioModel _usuario;
  bool _subindoImagem;
  String _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    setState(() {
      _subindoImagem == true;
    });
    _usuario = widget.usuario;
    _recuperarDadosUsuario();
  }

  _recuperarDadosUsuario()async{

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_idUsuarioLogado)
        .get();

    Map<String,dynamic> dados = snapshot.data;

    setState(() {
      _subindoImagem == false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        backgroundColor: temaPadrao.primaryColor,
        title: Image.asset(
          "assets/imagens/logoOficial.png",
          alignment: Alignment.center,
          width: 450,
          height: 150,
        ),
      ),
      body: Stack(children: <Widget>[

        ListView(children: <Widget>[

          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child:
                      Text("Resultado ultimo simulado",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22,
                            color: temaPadrao.primaryColor,
                            fontWeight:FontWeight.bold,
                          )
                      )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Nome : ",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(padding: EdgeInsets.only(right: 10),),
                          Text(
                            _usuario.nome +" "+ _usuario.sobreNome,
                            style: TextStyle(
                              color: temaPadrao.accentColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Especialidade : ",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(padding: EdgeInsets.only(right: 10),),
                          Text(
                            _usuario.especialidade,
                            style: TextStyle(
                              color: temaPadrao.accentColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Respostas certas : ",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(padding: EdgeInsets.only(right: 10),),
                          Text( _usuario.incorretas != null ?
                          _usuario.corretas.toString():
                          "não respondeu \n simulado",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: temaPadrao.accentColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Respostas erradas : ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(padding: EdgeInsets.only(right: 10),),
                          Text( _usuario.incorretas != null ?
                            _usuario.incorretas.toString():
                              "não respondeu \n simulado",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: temaPadrao.accentColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(),
                      ),
                    ],
                  ),
                ]
              )
          )
        ],),

      ],),
    );
  }
}
