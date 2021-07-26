import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/Usuario.dart';
import 'package:med_quest_adm/telas/Cadastro.dart';
import 'package:med_quest_adm/telas/Principal.dart';
import '../main.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    //recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);
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

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Principal()
          )
      );
    }).catchError((error) {
      setState(() {
        _mensagemErro = "Erro ao logar, verifique email e senha";
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    FirebaseUser usuarioLogado = await auth.currentUser();

    if (usuarioLogado != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Principal()
          )
      );
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
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Image.asset(
                    "assets/imagens/logoOficial.png",
                    color: temaPadrao.primaryColor,
                    width: 200,
                    height: 150,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16),
                  child: Text("Login ADM",
                      style: TextStyle(fontSize: 25,
                          color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                          focusedBorder: InputBorder.none,
                          hintText: "E-mail",
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
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
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Acessar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.white,height: 0,),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? Cadastre-se!",
                      style: TextStyle(
                          color: temaPadrao.accentColor
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Cadastro()
                          )
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
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
