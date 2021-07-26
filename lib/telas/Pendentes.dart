import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_quest_adm/model/Usuario.dart';
import 'package:med_quest_adm/model/UsuarioModel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../main.dart';
import 'UsuariosPendentes.dart';
import 'package:http/http.dart';

class Pendentes extends StatefulWidget {

  UsuarioModel usuario;
  Pendentes(this.usuario);

  @override
  _PendentesState createState() => _PendentesState();
}

class _PendentesState extends State<Pendentes> {

  UsuarioModel _usuario;
  File _imagemFrente;
  File _imagemVerso;
  String _urlImagemRecuperadaFrente;
  String _urlImagemRecuperadaVerso;
  String _status;
  String _token;
  bool _subindoImagem;
  String _idUsuarioLogado;

  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": "f7a2d074-1661-4b62-8956-4dc0d5d052e2",//kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color":"0xff61aef5",

        "small_icon":"https://firebasestorage.googleapis.com/v0/b/medquest-81996.appspot.com/o/logo%2FlogoOficial1.png?alt=media&token=8ee9bad8-8c33-4c33-b8b5-94741cba2c9a",

        "large_icon":"https://firebasestorage.googleapis.com/v0/b/medquest-81996.appspot.com/o/logo%2FlogoOficial1.png?alt=media&token=8ee9bad8-8c33-4c33-b8b5-94741cba2c9a",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  _liberarUsuario(String token)async{
    _status = "liberado";
    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "status" : _status,
    };
    db.collection("usuarios")
        .document(_usuario.idUsuario)
        .updateData(dadosAtualizar);

    _usuario= UsuarioModel();

    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => UsuariosPendentes()));
    sendNotification([_token],"Seu cadastro foi liberado","MedQuest");
  }
  _rejeitarUsuario()async{
    _status = "rejeitado";
    Firestore db = Firestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "status" : _status,
    };
    db.collection("usuarios")
        .document(_usuario.idUsuario)
        .updateData(dadosAtualizar);
    UsuarioModel usuario = UsuarioModel();

    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => UsuariosPendentes()));
    sendNotification([_token],"Seu cadastro foi rejeitado","MedQuest");
  }

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

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("usuarios")
        .document(_usuario.idUsuario)
        .get();

    Map<String,dynamic> dados = snapshot.data;
    _token = dados['tokenId'];

    setState(() {
      _subindoImagem == false;
    });
  }

  _abrirImagemFrente()async{
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("CRM frente",textAlign: TextAlign.center),
            content: GestureDetector(
                child: _usuario.urlCRMFrente !=null
                    ? Image.network(
                  _usuario.urlCRMFrente,
                  width: 350,
                  height: 350,
                ) : Container(
                  padding: EdgeInsets.all(5),
                  child:  Container(),
                )
            ),
            actions: <Widget>[
              FlatButton(
                color: temaPadrao.primaryColor,
                child: Text(
                  "Fechar",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
  _abrirImagemVerso()async{
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("CRM verso",textAlign: TextAlign.center),
            content: GestureDetector(
                child: _usuario.urlCRMVerso !=null
                    ? Image.network(
                  _usuario.urlCRMVerso,
                  width: 350,
                  height: 350,
                ) : Container(
                  padding: EdgeInsets.all(5),
                  child:  Container(),
                )
            ),
            actions: <Widget>[
              FlatButton(
                color: temaPadrao.primaryColor,
                child: Text(
                  "Fechar",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  _dialogLiberar()async{
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Confirmação",textAlign: TextAlign.center),
            content: Text("Deseja realmente liberar o acesso para "+ _usuario.nome+" "+_usuario.sobreNome+" ?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Fechar",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: temaPadrao.primaryColor,
                child: Text(
                  "Liberar",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                  _liberarUsuario(_usuario.tokenID);
                },
              )
            ],
          );
        }
    );
  }
  _dialogRejeitar()async{
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Confirmação",textAlign: TextAlign.center),
            content: Text("Deseja realmente rejeitar o acesso para "+ _usuario.nome+" "+_usuario.sobreNome+" ?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text(
                  "Fechar",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: temaPadrao.primaryColor,
                child: Text(
                  "Rejeitar",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                  _rejeitarUsuario();
                },
              )
            ],
          );
        }
    );
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
                                onTap: _abrirImagemFrente,
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
                                  onTap: _abrirImagemVerso,
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
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Container(
                      child: Text(
                        "Liberar Usuário",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: temaPadrao.primaryColor,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    onTap: (){
                      _dialogLiberar();
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      child: Text(
                        "Rejeitar Usuário",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    onTap: (){
                      _dialogRejeitar();
                    },
                  )
                ],
              )
            )
          ],),
    );
  }
}
