import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/UsuarioModel.dart';

import '../main.dart';

class Rejeitados extends StatefulWidget {

  UsuarioModel usuario;
  Rejeitados(this.usuario);

  @override
  _RejeitadosState createState() => _RejeitadosState();
}

class _RejeitadosState extends State<Rejeitados> {

  UsuarioModel _usuario;
  File _imagemFrente;
  File _imagemVerso;
  String _urlImagemRecuperadaFrente;
  String _urlImagemRecuperadaVerso;
  String _status = "liberado";
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
                      child: (_usuario.status == "pendente")?
                      Text("Usuário pendente",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25,
                            color: temaPadrao.primaryColor,
                            fontWeight:FontWeight.bold,
                          )
                      ):Text("Usuário Cadastrado",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25,
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
                            "E-mail : ",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(padding: EdgeInsets.only(right: 10),),
                          Text(
                            _usuario.email,
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
                            "CRM : ",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(padding: EdgeInsets.only(right: 10),),
                          Text(
                            _usuario.crm,
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
                      ),Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Status : ",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(padding: EdgeInsets.only(right: 10),),
                          (_usuario.status != "liberado")
                              ?Text(_usuario.status,style: TextStyle(color: Colors.red,fontSize: 20))
                              :Text(_usuario.status,style: TextStyle(color: Colors.green,fontSize: 20))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Frente",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "Verso",
                            style: TextStyle(
                                color: temaPadrao.accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                //frente
                                GestureDetector(
                                    child: _usuario.urlCRMFrente !=null
                                        ? Image.network(
                                      _usuario.urlCRMFrente,
                                      width: 100,
                                      height: 100,
                                    ) : Container(
                                      padding: EdgeInsets.all(16),
                                      child:  Container(),
                                    )
                                ),
                                //verso
                                GestureDetector(
                                    child: _usuario.urlCRMVerso !=null
                                        ? Image.network(
                                      _usuario.urlCRMVerso,
                                      width: 100,
                                      height: 100,
                                    ) : Container(
                                      padding: EdgeInsets.all(16),
                                      child:  Container(),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        padding:EdgeInsets.all(2) ,
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:  _subindoImagem == false
                        ?CircularProgressIndicator(
                      color: temaPadrao.primaryColor,
                    )
                        : Container(),
                  ),
                ],
              )
          )
        ],),
      ],),
    );
  }
}
