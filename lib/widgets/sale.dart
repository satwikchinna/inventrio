import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:inventrio/widgets/addSale.dart';
import '../models/saleModel.dart';
import '../database_helper.dart';

class Sales extends StatefulWidget {
  @override
  _SaleState createState() => new _SaleState();
}

class _SaleState extends State<Sales> {
 
  TextEditingController editingController = new TextEditingController();

  String newValue;
  List sales;
  List duplicateSales;

  var db = DatabaseHelper();
  @override
  initState() {
    super.initState();
    _getRecords();
  }

  Future<void> _getRecords() async {
    var res = await db.getAllSales();

    setState(() {
      sales = res;
      duplicateSales = sales;
    });
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
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("SALES"),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.black54,
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
              onPressed:() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Addsales()),
                              );
                            },
            ),
            body: Material(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Column(children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search sales',
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: duplicateSales.length,
                            itemBuilder: (_, int position) {
                              return new Card(
                                  color: Colors.lightBlueAccent,
                                  borderOnForeground: true,
                                  child: new ListTile(
                                    leading: CircleAvatar(
                                      child: new Text(
                                          "${duplicateSales[position]["itemname"]}"
                                              .substring(0, 1)),
                                    ),
                                    title: new Text(
                                        "${duplicateSales[position]["itemname"]}"
                                            .toUpperCase()),
                                    subtitle: new Text(
                                        "Quantity: ${Sale.fromMap(duplicateSales[position]).quantity} units"),
                                    trailing: new Text(
                                        "Price:${Sale.fromMap(duplicateSales[position]).sellingprice}"),
                                  ));
                            }))
                  ]),
                )))));
  }

  void filterSearchResults(String query) async{
   if(query.isNotEmpty){
     var db = DatabaseHelper();
     var res = await db.getSalesearch(query);
     if(res!= null){
 setState(() {
      
       duplicateSales = res;
     
       
     });
     }
     else if(res== null && query.isNotEmpty ){ setState(() {
      
       duplicateSales= [];
     
       
     });
     }
    
    
   }

   else{

     print("hey");
      setState(() {
       
       duplicateSales=sales;
       
     });
   }

  }
 

  loadAsyncData() async {
    var db = new DatabaseHelper();
    List updateditems = await db.getAllItems();
    return updateditems;
  }
}
