import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_quest_adm/model/EspecialidadeModel.dart';
import '../main.dart';
import 'Especialidades.dart';
class CadastroEspecialidades extends StatefulWidget {
  @override
  _CadastroEspecialidadesState createState() => _CadastroEspecialidadesState();
}

class _CadastroEspecialidadesState extends State<CadastroEspecialidades> {

  TextEditingController _controllerEspecialidade = TextEditingController();
  EspecialidadeModel _especialidade;
  String _mensagemErro = "";
  File _imagem;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  _salvarEspecialidade()async{

    String espec = _controllerEspecialidade.text;

    _especialidade.especialidades = espec;
    _especialidade.urlEspecialidade = _urlImagemRecuperada;

    Firestore db = Firestore.instance;
    db.collection("especialidades")
        .document(espec)
        .setData(_especialidade.toMap()).then((_) {

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Especialidades()));

    });
  }

  Future _recuperarImagens(String origemImagem)async{

    File imagemSelecionada;
    switch (origemImagem){
      case "galeria" :
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null){
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("especialidades")
        .child(_controllerEspecialidade.text+".jpg");

    //Upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);
    //Controlar o progresso
    task.events.listen((StorageTaskEvent storageEvent) {

      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagem = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });
    //recuperarURLimagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot)async{

    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  @override
  void initState() {
    super.initState();
    _especialidade = EspecialidadeModel.gerarId();
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
    ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text("Cadastrar especialidades",
                      style: TextStyle(fontSize: 22,
                        color: temaPadrao.primaryColor,
                        fontWeight:FontWeight.bold,
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: TextField(
                        controller: _controllerEspecialidade,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                            focusedBorder: InputBorder.none,
                            hintText: "Especialidade",
                            filled: true,
                            fillColor: temaPadrao.secondaryHeaderColor,
                            enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                borderSide: BorderSide(color: Colors.white,width: 0))
                        )
                    ),
                  ),
                  Padding(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //frente
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _mensagemErro = "";
                                });
                                _recuperarImagens("galeria");
                              },
                              child: _urlImagemRecuperada != null
                                  ? Image.network(
                                _urlImagemRecuperada,
                                width: 200,
                                height: 200,
                              )
                                  : Card(
                                color: temaPadrao.secondaryHeaderColor,
                                child: FlatButton(
                                  padding:EdgeInsets.all(32) ,
                                  child: Icon(Icons.add_photo_alternate,color: temaPadrao.accentColor),
                                  onPressed: (){
                                    if(_controllerEspecialidade.text == ""){
                                      setState(() {
                                        _mensagemErro = "Preencha a especialidade";
                                      });
                                    }else{
                                      setState(() {
                                        _mensagemErro = "";
                                      });
                                      _recuperarImagens("galeria");
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    padding:EdgeInsets.all(2) ,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                        child: Text(
                          "Cadastrar especialidade",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        color: temaPadrao.primaryColor,
                        elevation: 5,
                        padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                        onPressed: () {
                          if(_controllerEspecialidade.text.isNotEmpty ){
                            if(_urlImagemRecuperada.isNotEmpty){
                              setState(() {
                                _mensagemErro = "";
                              });
                              _salvarEspecialidade();
                            }else{
                              setState(() {
                                _mensagemErro = "escolha uma imagem";
                              });
                            }
                          }else{
                            setState(() {
                              _mensagemErro = "Preencha a especialidade";
                            });
                          }
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child:  _subindoImagem
                        ?CircularProgressIndicator()
                        : Container(),
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
      ),
    );
  }
}
