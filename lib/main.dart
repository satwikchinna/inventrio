import 'package:flutter/material.dart';
import './widgets/home.dart';

void main(){
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
        
       body: Home()
    )));
  }
  
}