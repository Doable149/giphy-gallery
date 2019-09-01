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
  Future<GiphyImagePost> imagesPost;
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

  @override
  void initState() {
    super.initState();
    imagesPost = fetchImagesJSON(search: this._search);
  }

  void _searchImages(){
    if(myController.text != _search){
      setState(() {
        _search = myController.text;
      });
      imagesPost = fetchImagesJSON(search: this._search);
    }
  }

  void _onTapDownPosition(TapDownDetails tapDownDetails){
    _globalPosition = tapDownDetails.globalPosition;
  }

  void clearTextEdit(){
    setState(() {
      _search = "";
    });
    imagesPost = fetchImagesJSON(search: this._search);
  }

  Widget galleryBuilder(BuildContext context, AsyncSnapshot<GiphyImagePost> snapshot){
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    if (snapshot.hasData) {
      List<GestureDetector> imagesWidgets = new List();
      snapshot.data.images.entries.forEach((entry) {
        FadeInImage image = FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: entry.value.urlPreview);

        GestureDetector gesture = GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(maintainState: true,
            builder: (context) => FullScreenImage(originalURL: entry.value.urlOriginal)));
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

    // Par défaut on affiche un spinner vu que le chargement n'est pas terminé
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    print('Rendu widget gallerie');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: getSearchTextField(
                  widget: widget,
                  controller: myController,
                  resetSearchCallback: clearTextEdit,
                  submitAction: () {
                    _searchImages();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  }
                ),      
              ),
              FutureBuilder<GiphyImagePost>(
                  future: imagesPost,
                  builder: galleryBuilder,
                ),
              ]
            ),
         )
      )
    );
  }
}

