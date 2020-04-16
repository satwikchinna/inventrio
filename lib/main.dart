import 'package:flutter/material.dart';
import './widgets/home.dart';

import './models/saleModel.dart';
import './database_helper.dart';

List sales;
void main() async{
 
   var db = new DatabaseHelper();
 
  //db.saveSale(new Sale(20,DateTime.now().toIso8601String(),50,1));
  sales = await db.getAllSales();
  print(sales.last["itemname"]);

 
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