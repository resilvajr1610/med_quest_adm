import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/EspecialidadeModel.dart';
import 'package:med_quest_adm/model/TemaModel.dart';
import 'package:med_quest_adm/telas/ItemTemas.dart';
import '../main.dart';
import 'CadastroTemas.dart';

class Temas extends StatefulWidget {

  @override
  _TemasState createState() => _TemasState();
}

class _TemasState extends State<Temas> {

  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListenerTemas()async{

    List<DropdownMenuItem<String>>_listaEspecialidades = List();
    TemaModel _tema;
    EspecialidadeModel _especialidade;
    

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("temas")
        //.where("especialidadeTema",isEqualTo: "esportes")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _removerTemas(String idTema){
    Firestore db = Firestore.instance;
    db.collection("temas")
        .document(idTema)
        .delete().then((_){

      db.collection("temas")
          .document(idTema)
          .delete();
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerTemas();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[
        Container(child: Text("Carregando temas")),
        CircularProgressIndicator()
      ],),
    );

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
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Temas",
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
                                builder: (context) => CadastroTemas()
                            )
                        );
                      },
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
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

                              List<DocumentSnapshot> temas = querySnapshot.documents.toList();
                              DocumentSnapshot documentSnapshot = temas[indice];
                              TemaModel temaModel = TemaModel.fromDocumentSnapshot(documentSnapshot);

                              return ItemTemas(
                                temaModel: temaModel,
                                onPressedRemover: (){
                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          title: Text("Confirmar"),
                                          content: Text("Deseja realmente excluir esse tema?"),
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
                                                _removerTemas(temaModel.id);
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
