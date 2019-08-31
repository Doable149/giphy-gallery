import 'package:flutter/material.dart';

TextField getSearchTextField({Widget widget, TextEditingController controller,Function submitAction,  Function resetSearchCallback}){

  return TextField(
                cursorColor: Colors.white,
                controller: controller,
                style: TextStyle(fontSize: 18.0, color: Colors.white),
                textInputAction: TextInputAction.search,
                onEditingComplete: submitAction,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,color: Colors.white),
                  hintText: 'Saisissez votre recherche',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                  suffixIcon: IconButton(
                    
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: (){
                      controller.clear();
                      resetSearchCallback();
                    }),
                  ),
                );
}