import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const giphyAPIKey = 'XDZzhTVnl85PiHArT9ru0Tmc6TBpi0Hv';
const giphyAPI = 'https://api.giphy.com/v1/gifs';
const giphySearchUrl = '$giphyAPI/search?api_key=$giphyAPIKey&q=';
const giphyTrendingUrl = '$giphyAPI/trending?api_key=$giphyAPIKey';

String giphyIdUrl (imageId) {
  return '$giphyAPI/$imageId?api_key=$giphyAPIKey';
}

Future<GiphyImagePost> fetchImagesJSON({String search, String id}) async {
    String url;

    if(search != null && search.length > 0){
      print(search);
      url = '$giphySearchUrl$search';
    }
    else{
      url = '$giphyTrendingUrl';
    }

    try{
      print("Lancement requête sur l'url : $url");
      final response = await http.get(url);

      if(response.statusCode == 200){
        return GiphyImagePost.fromJson(json.decode(response.body));
      }
      else{
        throw Exception('Erreur HTTP : ' + response.statusCode.toString());
      }
    }
    catch(e){
      print('Erreur de connexion lors de la récupération de la liste des gifs : ' + e.toString());
      
    }
}

class GiphyImagePost {
  final Map<String, GiphyImage> images;

  GiphyImagePost({this.images});

  factory GiphyImagePost.fromJson(Map<String, dynamic> json) {
    Map<String, GiphyImage> images = new Map();

    List<dynamic> imagesFromJSON;
    
    //Dans le cas d'une recherche par id data n'est pas un tableau mais un objet
    //vu qu'il n y a qu'une seule image
    if(json['data'] != null ){
        imagesFromJSON = json['data'];
    }

    imagesFromJSON.forEach((image) {
      images[image['id']] = new GiphyImage(
        image['images']['fixed_width_small']['url'],
        image['images']['original']['url']
      );
    });
    
    

    return GiphyImagePost(
      images: images
    );
  }
}

class GiphyImagePostOne
{
  final GiphyImage giphyImage;

  GiphyImagePostOne({this.giphyImage});

  factory GiphyImagePostOne.fromJson(Map<String, dynamic> json) {
    var image;

    if(json['data'] is Map<String, dynamic>){
      image = json['data'];
    } 
    else{
      print('Réponse incorrecte de Giphy');
      return null;
    }

    GiphyImage giphyImageConverted = new GiphyImage(
      image['images']['preview_gif']['url'],
        image['images']['original']['url']
    );

    return GiphyImagePostOne(giphyImage: giphyImageConverted);
  }
}

class GiphyImage
{
  String urlPreview = '';
  String urlOriginal = '';

  GiphyImage(this.urlPreview,this.urlOriginal);
  
}