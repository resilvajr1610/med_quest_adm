import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_quest_adm/model/TemaModel.dart';
import '../main.dart';
import 'Temas.dart';

class CadastroTemas extends StatefulWidget {
  @override
  _CadastroTemasState createState() => _CadastroTemasState();
}

class _CadastroTemasState extends State<CadastroTemas> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerTema= TextEditingController();
  String _mensagemErro = "";
  File _imagem;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;
  var valorSelecionado;
  TemaModel _tema;

  _salvarTema()async{

    String tema = _controllerTema.text;
    _tema.temas = tema;
    _tema.urlTemas = _urlImagemRecuperada;
    _tema.especialidadeTema = valorSelecionado;

    Firestore db = Firestore.instance;

    db.collection("lista"+_tema.especialidadeTema)
        .document(_tema.temas)
        .setData(_tema.toMapTema());

    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Temas()));

    db.collection("temasLista")
        .document(tema)
        .setData(_tema.toMap());

    db.collection("temas")
        .document(_tema.id)
        .setData(_tema.toMap()).then((_) {

      db.collection("lista"+_tema.especialidadeTema)
          .document(_tema.temas)
          .setData(_tema.toMapTema());

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Temas()));
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerEspecialidades()async{

  Firestore db = Firestore.instance;
  Stream<QuerySnapshot> stream = db
      .collection("especialidades")
      .snapshots();

  stream.listen((dados) {
  _controller.add(dados);
  });
  }

  Future _uploadImagem()async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("temas")
        .child(valorSelecionado)
        .child(_controllerTema.text+".jpg");

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

  @override
  void initState() {
    super.initState();
    _tema = TemaModel.gerarId();
    _adicionarListenerEspecialidades();
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
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child:Text("Cadastrar temas",
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
                      stream:_controller.stream,
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
                                    textAlign: TextAlign.center,
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
                                    valorSelecionado = valor;
                                  });
                                },
                                value: valorSelecionado,
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
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                        controller: _controllerTema,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 15,color: temaPadrao.accentColor),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(color: temaPadrao.accentColor),
                            hintText: "Tema",
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
                          if(_controllerTema.text == ""){
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
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                        child: Text(
                          "Cadastrar tema",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        color: temaPadrao.primaryColor,
                        elevation: 5,
                        padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                        onPressed: () {
                          if(_controllerTema.text.isNotEmpty ){
                            _salvarTema();
                          }else{
                            setState(() {
                              _mensagemErro = "Preencha especialidade e tema";
                            });
                          }
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child:  _subindoImagem
                        ?CircularProgressIndicator()
                        : Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
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
