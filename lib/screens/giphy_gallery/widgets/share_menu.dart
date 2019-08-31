import 'package:flutter/material.dart';
import 'package:share/share.dart';

/**
* Renvoi du menu de partage d'url
*/
PopupMenuItem getShareMenuItem(String url){
  return PopupMenuItem(
    value: url,
    child: FlatButton(
                onPressed: (){
                  Share.share(url);
                },
                child: Row(children: <Widget>[
                  Icon(Icons.share),
                  Text("Partager l'url de cette image")
                  ], )
              )
          );
}