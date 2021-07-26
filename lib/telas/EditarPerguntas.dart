import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_quest_adm/model/PerguntaModel.dart';
import '../main.dart';
import 'Perguntas.dart';

class EditarPerguntas extends StatefulWidget {

  PerguntaModel perguntaModel;
  EditarPerguntas(this.perguntaModel);

  @override
  _EditarPerguntasState createState() => _EditarPerguntasState();
}

class _EditarPerguntasState extends State<EditarPerguntas> {

  TextEditingController _controllerPergunta = TextEditingController();
  TextEditingController _controllerResposta1 = TextEditingController();
  TextEditingController _controllerResposta2 = TextEditingController();
  TextEditingController _controllerResposta3 = TextEditingController();
  TextEditingController _controllerResposta4 = TextEditingController();
  TextEditingController _controllerResposta5 = TextEditingController();
  TextEditingController _controllerExplicacao = TextEditingController();
  PerguntaModel _pergunta;
  bool _subindoImagem;
  String _urlImagemRecuperada;
  File _imagem;

  @override
  void initState() {
    super.initState();
    setState(() {
      _subindoImagem == true;
    });
    _pergunta = widget.perguntaModel;
    _recuperarDadosPergunta();
    _controllerPergunta = TextEditingController(text: _pergunta.perguntas);
    _controllerResposta1 = TextEditingController(text: _pergunta.resposta1);
    _controllerResposta2 = TextEditingController(text: _pergunta.resposta2);
    _controllerResposta3 = TextEditingController(text: _pergunta.resposta3);
    _controllerResposta4 = TextEditingController(text: _pergunta.resposta4);
    _controllerResposta5 = TextEditingController(text: _pergunta.resposta5);
    _controllerExplicacao = TextEditingController(text: _pergunta.explicaoResposta);
  }

  _recuperarDadosPergunta()async{

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("simuladoPergunta")
        .document(_pergunta.id)
        .get();

    Map<String,dynamic> dados = snapshot.data;

    setState(() {
      _subindoImagem == false;
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

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot)async{

    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _pergunta.urlPergunta = url;
    });
  }

    Future _uploadImagem()async{
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageReference pastaRaiz = storage.ref();
      StorageReference arquivo = pastaRaiz
          .child("perguntas")
          .child(_pergunta.especialidadePergunta)
          .child(_pergunta.temaPergunta)
          .child(_pergunta.id+".jpg");

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

  _salvarPergunta()async{

    String pergunta = _controllerPergunta.text;
    _pergunta.perguntas = pergunta;
    _pergunta.resposta1 = _controllerResposta1.text;
    _pergunta.resposta2 = _controllerResposta2.text;
    _pergunta.resposta3 = _controllerResposta3.text;
    _pergunta.resposta4 = _controllerResposta4.text;
    _pergunta.resposta5 = _controllerResposta5.text;
    _pergunta.explicaoResposta = _controllerExplicacao.text;
    if(_urlImagemRecuperada!=null){
      _pergunta.urlPergunta = _urlImagemRecuperada;
    }

    Firestore db = Firestore.instance;

    db.collection("simuladoPergunta")
        .document(_pergunta.id)
        .updateData(_pergunta.toMap()).then((_) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Perguntas()));
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
                      Text("Editar Pergunta",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25,
                            color: temaPadrao.primaryColor,
                            fontWeight:FontWeight.bold,
                          )
                      )
                  ),
                  GestureDetector(
                      onTap: () {
                          _recuperarImagens("galeria");
                      },
                        child: _pergunta.urlPergunta !=null
                            ? Image.network(
                          _pergunta.urlPergunta,
                          width: 100,
                          height: 100,
                        ) : Container(
                          padding: EdgeInsets.all(16),
                          child:  Container(),
                        )
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pergunta : ",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Expanded(
                                  child: TextField(
                                      controller: _controllerPergunta,
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        focusedBorder: InputBorder.none,
                                        fillColor: temaPadrao.secondaryHeaderColor,
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 20,width: 20,),
                            Text(
                              "Resposta A (correta) : ",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Expanded(
                                  child: TextField(
                                      controller: _controllerResposta1,
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        focusedBorder: InputBorder.none,
                                        fillColor: temaPadrao.secondaryHeaderColor,
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 20,width: 20,),
                            Text(
                              "Resposta B : ",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Expanded(
                                  child: TextField(
                                      controller: _controllerResposta2,
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        focusedBorder: InputBorder.none,
                                        fillColor: temaPadrao.secondaryHeaderColor,
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 20,width: 20,),
                            Text(
                              "Resposta C : ",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Expanded(
                                  child: TextField(
                                      controller: _controllerResposta3,
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        focusedBorder: InputBorder.none,
                                        fillColor: temaPadrao.secondaryHeaderColor,
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 20,width: 20,),
                            Text(
                              "Resposta D : ",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Expanded(
                                  child: TextField(
                                      controller: _controllerResposta4,
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        focusedBorder: InputBorder.none,
                                        fillColor: temaPadrao.secondaryHeaderColor,
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 20,width: 20,),
                            Text(
                              "Resposta E : ",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Expanded(
                                  child: TextField(
                                      controller: _controllerResposta5,
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        focusedBorder: InputBorder.none,
                                        fillColor: temaPadrao.secondaryHeaderColor,
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 20,width: 20,),
                            Text(
                              "Explicação Resposta : ",
                              style: TextStyle(
                                  color: temaPadrao.accentColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10,left: 10),
                                child: Expanded(
                                  child: TextField(
                                      controller: _controllerExplicacao,
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        focusedBorder: InputBorder.none,
                                        fillColor: temaPadrao.secondaryHeaderColor,
                                      )
                                  ),
                                )
                            ),
                            SizedBox(height: 30,width: 30,),
                          ],
                        ),
                      ],
                    ),
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
        SizedBox(height: 20,width: 20,),
        Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                child: Text(
                  "Editar Pergunta",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
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
                _salvarPergunta();
              },
            )
        )
      ],),
    );
  }
}
