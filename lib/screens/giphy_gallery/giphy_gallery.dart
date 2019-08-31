import 'package:flutter/material.dart';
import 'package:tp_giphy_owen/screens/fullscren_image/fullscreen_image.dart';
import 'package:tp_giphy_owen/screens/giphy_gallery/widgets/search_textfield.dart';
import 'package:tp_giphy_owen/services/images.dart';
import 'package:transparent_image/transparent_image.dart';

import 'widgets/share_menu.dart';

class GiphyGallery extends StatefulWidget{
  final String title = "Galerie giphy";
  GiphyGallery({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GiphyGalleryState();
}

class _GiphyGalleryState extends State<GiphyGallery>{
  final List<PopupMenuItem> menuItems = new List();
  String _search = "";
  Offset _globalPosition;
  String lastImageIdClicked;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _searchImages(){
    setState(() {
      _search = myController.text;
    });
  }

  void _onTapDownPosition(TapDownDetails tapDownDetails){
    _globalPosition = tapDownDetails.globalPosition;
  }

  void resetState(){
    setState(() {
      _search = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Rendu widget gallerie');
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: getSearchTextField(widget: widget,
                      controller: myController,
                      resetSearchCallback: () {
                        setState(() {
                          _search = "";
                        });
                      },
                      submitAction: () {
                        _searchImages();
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
              ),      
            ),
            FutureBuilder<GiphyImagePost>(
                  future: fetchImagesJSON(search: this._search),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<GestureDetector> imagesWidgets = new List();
                      snapshot.data.images.entries.forEach((entry) {
                        FadeInImage image = FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: entry.value.urlPreview);
                        

                        GestureDetector gesture = GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImage(originalURL: entry.value.urlOriginal)));
                          },
                          onTapDown: _onTapDownPosition,
                          onLongPress:() { 
                            showMenu(
                              items: <PopupMenuEntry>[
                                getShareMenuItem(entry.value.urlOriginal)
                              ],
                              context: context,
                              position: RelativeRect.fromRect(
                                    _globalPosition & Size(40, 40), // smaller rect, the touch area
                                    overlay.semanticBounds )
                            );
                          },
                          child: image,
                        );

                        imagesWidgets.add(gesture); 
        
                      });
                      return Expanded(
                        flex: 9,
                        child: GridView.count(
                            crossAxisCount: 3,
                            children: imagesWidgets,
                            childAspectRatio: (200 / 100),
                        )
                      );
                    }
                    else if (snapshot.hasError)
                    {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ]
            ),
         )
      )
    );
  }
}

