import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/Usuario.dart';
import 'package:med_quest_adm/telas/Principal.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../main.dart';
import 'package:http/http.dart';

class Cadastro extends StatefulWidget {

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerRepetirSenha = TextEditingController();
  String _mensagemErro = "";
  String _idOneSignal;

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

  _validarCampos()async {
    //recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String repetirSenha = _controllerRepetirSenha.text;

    if (email.isNotEmpty) {
      if (senha.isNotEmpty) {
        if(repetirSenha == senha && repetirSenha.isNotEmpty){
          setState(() {
            _mensagemErro = "";
          });
          var status = await OneSignal.shared.getDeviceState();
          String tokenId = status.userId;
          Usuario usuario = Usuario();
          usuario.email = email;
          usuario.senha = senha;
          usuario.idOneSignal = tokenId;
          sendNotification([tokenId]," Cadastrado com Sucesso!","MedQuest");
          _cadastrarUsuario(usuario);
        }else{
          setState(() {
            _mensagemErro = "Senhas não são iguais";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha uma senha maior que 6 caracteres";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha seu email";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      //salvar dados do usuario
      Firestore db = Firestore.instance;
      db.collection("usuariosAdm")
          .document(firebaseUser.uid)
          .setData(usuario.toMap());

      db.collection("token")
          .document("token")
          .setData(usuario.toMap());

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Principal()));

    }).catchError((error){
      setState(() {
        _mensagemErro = " Erro ao cadastrar usuario";
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    FirebaseUser usuarioLogado = await auth.currentUser();

    if (usuarioLogado != null) {
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(5),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Image.asset(
                    "assets/imagens/logoOficial.png",
                    color: temaPadrao.primaryColor,
                    width: 280,
                    height: 80,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("E-mail",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                          focusedBorder: InputBorder.none,
                          hintText: "E-mail",
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("Senha",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Senha",
                        filled: true,
                        fillColor: temaPadrao.secondaryHeaderColor,
                        enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                            borderSide: BorderSide(color: Colors.white,width: 0))
                    )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Divider(color: Colors.white,height: 0,),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25,bottom: 4),
                  child: Text("Repetir senha",
                      style: TextStyle(fontSize: 15,
                          color: temaPadrao.accentColor)),
                ),
                TextField(
                    controller: _controllerRepetirSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Repetir Senha",
                        filled: true,
                        fillColor: temaPadrao.secondaryHeaderColor,
                        enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                            borderSide: BorderSide(color: Colors.white,width: 0))
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Finalizar",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      color: temaPadrao.primaryColor,
                      elevation: 5,
                      padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {

                        _validarCampos();
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
