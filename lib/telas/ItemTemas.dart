import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/TemaModel.dart';
import '../main.dart';

class ItemTemas extends StatelessWidget {

  TemaModel temaModel;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ItemTemas(
      {
        @required this.temaModel,
        this.onTapItem,
        this.onPressedRemover
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(children:<Widget> [
                  Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          temaModel.temas + " - " +temaModel.especialidadeTema,
                          style: TextStyle(
                              color: temaPadrao.accentColor,
                              fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              if(this.onPressedRemover != null)
          Expanded(
          flex: 1,
          child: FlatButton(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            onPressed: this.onPressedRemover,
            child: Icon(Icons.delete,color: Colors.red,),
          )
      )
      ],
    ),
    ),
    ),
    );
  }
}
