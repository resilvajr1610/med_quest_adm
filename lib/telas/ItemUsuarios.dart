import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/UsuarioModel.dart';
import '../main.dart';

class ItemUsuarios extends StatelessWidget {

  UsuarioModel usuarioModel;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;
  BuildContext context;

  ItemUsuarios(
      {
        @required this.usuarioModel,
        this.onTapItem,
        this.onPressedRemover
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(children:<Widget> [
                  Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          usuarioModel.nome+" "+usuarioModel.sobreNome,
                          style: TextStyle(
                            color: temaPadrao.accentColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
              ),

      ],
    ),
    ),
    ),
    );
  }
}
