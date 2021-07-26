import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/EspecialidadeModel.dart';
import 'package:med_quest_adm/telas/CadastroEspecialidades.dart';
import 'package:med_quest_adm/telas/ItemEspecialidades.dart';

import '../main.dart';

class Especialidades extends StatefulWidget {

  @override
  _EspecialidadesState createState() => _EspecialidadesState();
}

class _EspecialidadesState extends State<Especialidades> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;

  Future<Stream<QuerySnapshot>> _adicionarListenerEspecialidades()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("especialidades")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _removerEspecialidades(String idEspecialidade){
    Firestore db = Firestore.instance;
    db.collection("especialidades")
        .document(idEspecialidade)
        .delete().then((_){

      db.collection("especialidades")
          .document(idEspecialidade)
          .delete();
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerEspecialidades();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[
        Text("Carregando especialidades"),
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
                Text("Especialidades",
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
                              builder: (context) => CadastroEspecialidades()
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

                            List<DocumentSnapshot> especialidades = querySnapshot.documents.toList();
                            DocumentSnapshot documentSnapshot = especialidades[indice];
                            EspecialidadeModel especialidadeModel = EspecialidadeModel.fromDocumentSnapshot(documentSnapshot);

                            return ItemEspecialidades(
                              especialidadeModel: especialidadeModel,
                              onPressedRemover: (){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("Confirmar"),
                                        content: Text("Deseja realmente excluir essa especialidade?"),
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
                                              _removerEspecialidades(especialidadeModel.id);
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
