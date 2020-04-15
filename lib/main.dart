import 'package:flutter/material.dart';
import './widgets/home.dart';

import './models/itemModel.dart';
import './database_helper.dart';
List _items;

void main() async{
 
   var db = new DatabaseHelper();
 

  _items = await db.getAllItems();

 
  runApp(
    myApp()
   
  );
}

class myApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return( MaterialApp(
      title:"INVENTRIO",
      theme: ThemeData(
       
       buttonTheme: ButtonThemeData(
          height: 106,
          minWidth: 180,
       )),
      debugShowCheckedModeBanner: false,
      home:Scaffold( 
        appBar:AppBar(
          title:Center( child:Text("INVENTRIO")),
          backgroundColor: Colors.lightBlue,
        ),
        
       body: Home(items: _items,)
    )));
  }
  
}