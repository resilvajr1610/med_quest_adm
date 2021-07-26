import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/EspecialidadeModel.dart';
import 'package:med_quest_adm/model/PerguntaModel.dart';
import '../main.dart';
import 'CadastroPerguntas.dart';
import 'ItemPerguntas.dart';

class Perguntas extends StatefulWidget {

  @override
  _PerguntasState createState() => _PerguntasState();
}

class _PerguntasState extends State<Perguntas> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  final _controllerTema = StreamController<QuerySnapshot>.broadcast();
  final _controllerEspecialidade = StreamController<QuerySnapshot>.broadcast();
  PerguntaModel _perguntaModel = PerguntaModel();
  var valorSelecionadoTema;
  var valorSelecionadoEspecialidade;

  Future<Stream<QuerySnapshot>> _adicionarListenerFiltrar()async{

    Firestore db = Firestore.instance;

    Query query = db.collection("simuladoPergunta");
    if(valorSelecionadoEspecialidade != null){
      query = query.where("especialidadePergunta",isEqualTo: valorSelecionadoEspecialidade);
    }
    if(valorSelecionadoTema != null){
      query = query.where("temaPergunta",isEqualTo: valorSelecionadoTema);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerPerguntas()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("simuladoPergunta")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerTemas()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("temasLista")
        .snapshots();

    stream.listen((dados) {
      _controllerTema.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerEspecialidade()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("especialidades")
        .snapshots();

    stream.listen((dados) {
      _controllerEspecialidade.add(dados);
    });
  }

  _removerPerguntas(String idPergunta){
    Firestore db = Firestore.instance;
    db.collection("simuladoPergunta")
        .document(idPergunta)
        .delete().then((_){

      db.collection("simuladoPergunta")
          .document(idPergunta)
          .delete();
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerPerguntas();
    _adicionarListenerEspecialidade();
    _adicionarListenerTemas();
  }

  var carregandoDados = Center(
    child: Column(children: <Widget>[
      Container(child: Text("Carregando perguntas")),
      CircularProgressIndicator()
    ],),
  );

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
      body: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Perguntas",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25,
                        color: temaPadrao.primaryColor,
                        fontWeight:FontWeight.bold,
                      )
                  ),
                  SizedBox(
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: temaPadrao.primaryColor,
                      onPressed: () {
                        // Abre tela para criar item de lista
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadastroPerguntas()
                            )
                        );
                      },
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Filtrar por especialidade : ",
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ),
              ),
              SizedBox(height: 10,),
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
                  stream:_controllerEspecialidade.stream,
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
                                valorSelecionadoEspecialidade = valor;
                                _adicionarListenerFiltrar();
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
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Filtrar por tema : ",
                    style: TextStyle(fontSize: 20,
                      color: temaPadrao.accentColor,
                    )
                ),
              ),
              SizedBox(height: 10,),
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
                  stream:_controllerTema.stream,
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
                                textAlign: TextAlign.start,
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
                                _adicionarListenerFiltrar();
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
              SizedBox(height: 10,),
              Expanded(
                child: StreamBuilder(
                  stream: _controller.stream,
                  builder: (context,snapshot){

                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return carregandoDados;
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:

                        if(snapshot.hasError)
                          return Text("Erro ao carregar dados!");

                        QuerySnapshot querySnapshot = snapshot.data;
                        return ListView.builder(
                            itemCount: querySnapshot.documents.length,
                            itemBuilder: (_,indice){

                              List<DocumentSnapshot> perguntas = querySnapshot.documents.toList();
                              DocumentSnapshot documentSnapshot = perguntas[indice];
                              PerguntaModel perguntamodel = PerguntaModel.fromDocumentSnapshot(documentSnapshot);

                              return ItemPerguntas(
                                perguntaModel: perguntamodel,
                                onTapItem: (){Navigator.pushNamed(
                                    context,
                                    "/perguntas",
                                    arguments: perguntamodel
                                );},
                                onPressedRemover: (){
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          title: Text("Confirmar"),
                                          content: Text("Deseja realmente excluir essa pergunta?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Cancelar",
                                                style: TextStyle(
                                                    color: Colors.grey
                                                ),
                                              ),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              color: Colors.red,
                                              child: Text(
                                                "Remover",
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                              onPressed: (){
                                                _removerPerguntas(perguntamodel.id);
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      }
                                  );
                                },
                              );
                            }
                        );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
