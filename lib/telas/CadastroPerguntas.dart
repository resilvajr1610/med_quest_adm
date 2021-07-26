import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_quest_adm/model/PerguntaModel.dart';
import 'package:med_quest_adm/model/TemaModel.dart';
import '../main.dart';
import 'Perguntas.dart';

class CadastroPerguntas extends StatefulWidget {
  @override
  _CadastroPerguntasState createState() => _CadastroPerguntasState();
}

class _CadastroPerguntasState extends State<CadastroPerguntas> {

  final _controllerListaEspecialidade = StreamController<QuerySnapshot>.broadcast();
  final _controllerListaTema = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerPergunta= TextEditingController();
  TextEditingController _controllerResposta1= TextEditingController();
  TextEditingController _controllerResposta2= TextEditingController();
  TextEditingController _controllerResposta3= TextEditingController();
  TextEditingController _controllerResposta4= TextEditingController();
  TextEditingController _controllerResposta5= TextEditingController();
  TextEditingController _controllerExplicacao= TextEditingController();
  var valorSelecionadoResposta;
  var valorSelecionadoEspecialidade;
  var valorSelecionadoTema;
  String _urlImagemRecuperada;
  bool _subindoImagem = false;
  String _mensagemErro = "";
  PerguntaModel _pergunta;
  TemaModel _tema;
  File _imagem;

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

  Future<Stream<QuerySnapshot>> _adicionarListenerEspecialidades()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("especialidades")
        .snapshots();

    stream.listen((dados) {
      _controllerListaEspecialidade.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerTemas()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("temasLista")
        .snapshots();

    stream.listen((dados) {
      _controllerListaTema.add(dados);
    });
  }

  Future _uploadImagem()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("perguntas")
        .child(valorSelecionadoEspecialidade)
        .child(valorSelecionadoTema)
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

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot)async{

    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecuperada = url;
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
    //_pergunta.respostaCorreta = valorSelecionadoResposta;
    _pergunta.urlPergunta = _urlImagemRecuperada;
    _pergunta.especialidadePergunta = valorSelecionadoEspecialidade;
    _pergunta.temaPergunta = valorSelecionadoTema;

    Firestore db = Firestore.instance;

    db.collection("simuladoPergunta")
        .document(_pergunta.id)
        .setData(_pergunta.toMap()).then((_) {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Perguntas()));
    });
  }

  @override
  void initState() {
    super.initState();
    _pergunta = PerguntaModel.gerarId();
    _adicionarListenerEspecialidades();
    _adicionarListenerTemas();
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
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 5,right: 10,left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child:Text("Cadastrar perguntas",
                          style: TextStyle(fontSize: 22,
                            color: temaPadrao.primaryColor,
                            fontWeight:FontWeight.bold,
                          )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          color: temaPadrao.secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: temaPadrao.secondaryHeaderColor,width: 1,
                          )
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream:_controllerListaEspecialidade.stream,
                        builder: (context,snapshot){
                          if(!snapshot.hasData){
                            Text("Carregando");
                          }else {
                            List<DropdownMenuItem> espItems = [];
                            for (int i = 0; i < snapshot.data.documents.length;i++){
                              DocumentSnapshot snap=snapshot.data.documents[i];
                              espItems.add(
                                  DropdownMenuItem(
                                    child: Text(
                                      snap.documentID,
                                      style: TextStyle(color: temaPadrao.accentColor),
                                    ),
                                    value: "${snap.documentID}",
                                  )
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButton(
                                  items:espItems,
                                  onChanged:(valor){
                                    setState(() {
                                      valorSelecionadoEspecialidade = valor;
                                    });
                                  },
                                  value: valorSelecionadoEspecialidade,
                                  isExpanded: false,
                                  hint: new Text(
                                    "Escolha uma especialidade",
                                    style: TextStyle(color: temaPadrao.accentColor ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                    ),
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          color: temaPadrao.secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: temaPadrao.secondaryHeaderColor,width: 1,
                          )
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream:_controllerListaTema.stream,
                        builder: (context,snapshot){
                          if(!snapshot.hasData){
                            Text("Carregando");
                          }else {
                            List<DropdownMenuItem> espItems = [];
                            for (int i = 0; i < snapshot.data.documents.length;i++){
                              DocumentSnapshot snap=snapshot.data.documents[i];
                              espItems.add(
                                  DropdownMenuItem(
                                    child: Text(
                                      snap.documentID,
                                      style: TextStyle(color: temaPadrao.accentColor,fontSize: 9),
                                    ),
                                    value: "${snap.documentID}",
                                  )
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButton(
                                  items:espItems,
                                  onChanged:(valor){
                                    setState(() {
                                      valorSelecionadoTema = valor;
                                    });
                                  },
                                  value: valorSelecionadoTema,
                                  isExpanded: false,
                                  hint: new Text(
                                    "Escolha um tema",
                                    style: TextStyle(color: temaPadrao.accentColor ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                          controller: _controllerPergunta,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: temaPadrao.accentColor),
                              hintText: "Escreva a pergunta",
                              filled: true,
                              fillColor: temaPadrao.secondaryHeaderColor,
                              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Colors.white,width: 0))
                          )
                      ),
                    ),
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
                            if(_controllerPergunta.text == ""){
                              setState(() {
                                _mensagemErro = "Preencha a pergunta";
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
                    Container(
                      padding: EdgeInsets.all(10),
                      child:  _subindoImagem
                          ?CircularProgressIndicator()
                          : Container(),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          "Opções de Resposta :",
                          style: TextStyle(color: temaPadrao.accentColor, fontSize: 15),
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 25,top: 10,bottom: 2),
                        child: Row(
                            children:[
                              Text(
                                "Resposta A",
                                style: TextStyle(color: temaPadrao.accentColor, fontSize: 15),
                              ),
                            ]
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,bottom: 10),
                      child: TextField(
                          controller: _controllerResposta1,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          style: TextStyle(fontSize: 13,color: temaPadrao.accentColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: temaPadrao.accentColor),
                              hintText: "Preencha a resposta (correta)",
                              filled: true,
                              fillColor: temaPadrao.secondaryHeaderColor,
                              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Colors.white,width: 0))
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25,top: 2,bottom: 2),
                      child: Row(
                          children:[
                            Text(
                              "Resposta B",
                              style: TextStyle(color: temaPadrao.accentColor, fontSize: 15),
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,bottom: 10),
                      child: TextField(
                          controller: _controllerResposta2,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          style: TextStyle(fontSize: 13,color: temaPadrao.accentColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: temaPadrao.accentColor),
                              hintText: "Preencha a resposta",
                              filled: true,
                              fillColor: temaPadrao.secondaryHeaderColor,
                              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Colors.white,width: 0))
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25,top: 2,bottom: 2),
                      child: Row(
                          children:[
                            Text(
                              "Resposta C",
                              style: TextStyle(color: temaPadrao.accentColor, fontSize: 15),
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,bottom: 10),
                      child: TextField(
                          controller: _controllerResposta3,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          style: TextStyle(fontSize: 13,color: temaPadrao.accentColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: temaPadrao.accentColor),
                              hintText: "Preencha a resposta",
                              filled: true,
                              fillColor: temaPadrao.secondaryHeaderColor,
                              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Colors.white,width: 0))
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25,top: 2,bottom: 2),
                      child: Row(
                          children:[
                            Text(
                              "Resposta D",
                              style: TextStyle(color: temaPadrao.accentColor, fontSize: 15),
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,bottom: 10),
                      child: TextField(
                          controller: _controllerResposta4,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          style: TextStyle(fontSize: 13,color: temaPadrao.accentColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: temaPadrao.accentColor),
                              hintText: "Preencha a resposta",
                              filled: true,
                              fillColor: temaPadrao.secondaryHeaderColor,
                              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Colors.white,width: 0))
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25,top: 2,bottom: 2),
                      child: Row(
                          children:[
                            Text(
                              "Resposta E",
                              style: TextStyle(color: temaPadrao.accentColor, fontSize: 15),
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,right: 16,bottom: 10),
                      child: TextField(
                          controller: _controllerResposta5,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          style: TextStyle(fontSize: 13,color: temaPadrao.accentColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: temaPadrao.accentColor),
                              hintText: "Preencha a resposta",
                              filled: true,
                              fillColor: temaPadrao.secondaryHeaderColor,
                              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Colors.white,width: 0))
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25,top: 16),
                      child: Row(
                          children:[
                            Text(
                              "Explicação",
                              style: TextStyle(color: temaPadrao.accentColor, fontSize: 15),
                            ),
                          ]
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                          controller: _controllerExplicacao,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: temaPadrao.accentColor),
                              hintText: "Explicação resposta",
                              filled: true,
                              fillColor: temaPadrao.secondaryHeaderColor,
                              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                                  borderSide: BorderSide(color: Colors.white,width: 0))
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: RaisedButton(
                          child: Text(
                            "Cadastrar pergunta",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: temaPadrao.primaryColor,
                          elevation: 5,
                          padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)
                          ),
                          onPressed: () {
                            if(_controllerPergunta.text.isNotEmpty ){
                              setState(() {
                                _mensagemErro = "";
                              });
                              _salvarPergunta();
                            }else{
                              setState(() {
                                _mensagemErro = "Preencha todos os campos";
                              });
                            }
                          }),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
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
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
