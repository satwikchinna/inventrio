import 'package:flutter/material.dart';
import 'package:inventrio/database_helper.dart';
class Dashboard extends StatefulWidget{


 



  @override
  _dashboard createState() => new _dashboard();
}

class _dashboard extends State<Dashboard> {
List<double> monthlyIncomes;
List<double> monthlyPurchases;
String topsellingItem;
String highlyprofitableItem;

@override
void initState(){
getdashboaardDetails();


  }


  void getdashboaardDetails() async{
var db = DatabaseHelper();
monthlyIncomes = await db.gettotalmIncomes();
monthlyPurchases = await db.gettotalmPurchases();


  }
  @override
  Widget build(BuildContext context) {
   
    return (MaterialApp(
        title: "INVENTRIO",
        theme: ThemeData(
            buttonTheme: ButtonThemeData(
          height: 20,
          minWidth: 50,
        )),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Text("DASHBOARD"),
              backgroundColor: Colors.lightBlue,
            ))));
            
  }
  
}