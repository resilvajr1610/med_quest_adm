import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/telas/EditarPerguntas.dart';
import 'package:med_quest_adm/telas/Pendentes.dart';
import 'package:med_quest_adm/telas/Rejeitados.dart';
import 'package:med_quest_adm/telas/ResultadoUsuarios.dart';

class RouteGenerator{

    static Route<dynamic> generateRoute(RouteSettings settings){
      final args = settings.arguments;

      switch(settings.name){
        case "/pendentes" :
          return MaterialPageRoute(
              builder: (_) => Pendentes(args)
          );
        case "/rejeitados" :
          return MaterialPageRoute(
              builder: (_) => Rejeitados(args)
          );
        case "/resultados" :
          return MaterialPageRoute(
              builder: (_) => ResultadoUsuarios(args)
          );
        case "/perguntas" :
          return MaterialPageRoute(
              builder: (_) => EditarPerguntas(args)
          );

        default :
          _erroRota();
      }
    }
    static  Route <dynamic> _erroRota(){
      return MaterialPageRoute(
          builder:(_){
            return Scaffold(
              appBar: AppBar(
                title: Text("Tela não encontrada"),
              ),
              body: Center(
                child: Text("Tela não encontrada"),
              ),
            );
          });
    }
  }