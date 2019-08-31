import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FullScreenImage extends StatelessWidget{
  final String originalURL;

  FullScreenImage({this.originalURL, Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: <Widget>[ 
          Center(
            child: CircularProgressIndicator()
          ),
          Center(
            child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: this.originalURL)
          )
        ]
        )
    );
  }
}