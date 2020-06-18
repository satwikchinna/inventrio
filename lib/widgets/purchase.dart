import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inventrio/widgets/addPurchase.dart';
import '../models/purchaseModel.dart';
import '../database_helper.dart';

class Purchases extends StatefulWidget {
  @override
  _PurchaseState createState() => new _PurchaseState();
}

class _PurchaseState extends State<Purchases> {
 
  TextEditingController editingController = new TextEditingController();

  String newValue;
  List purchases;
  List duplicatePurchases;

  var db = DatabaseHelper();
  @override
  initState() {
    super.initState();
    _getRecords();
  }

  Future<void> _getRecords() async {
    var res = await db.getAllPurchases();

    setState(() {
      purchases = res;
      duplicatePurchases = purchases;
    });
  }

   Future<void> deletePurchase(int id,quantity,name) async {
    await db.deletePurchase(id,quantity,name);
    _getRecords();
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
              title: Text("Purchases"),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
              onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Addpurchases(suggestion: null,)),
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
                        labelText: 'Search purchases',
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: duplicatePurchases.length,
                            itemBuilder: (_, int position) {
                              return new Card(
                                  color: Colors.lightBlueAccent,
                                  borderOnForeground: true,
                                  child: new ListTile(
                                    leading: CircleAvatar(
                                      child: new Text(
                                          "${Purchase.fromMap(duplicatePurchases[position]).quantity}"
                                             ),
                                    ),
                                    title: new Text(
                                        "${duplicatePurchases[position]["itemname"]}"
                                            .toUpperCase()),
                                    subtitle: new Text(
                                        "${Purchase.fromMap(duplicatePurchases[position]).doc.substring(0,10)}" 
                                        "  Price:${Purchase.fromMap(duplicatePurchases[position]).costprice}"),
                                    trailing: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.red,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      deletePurchase(Purchase.fromMap(purchases[position]).purchaseid,Purchase.fromMap(purchases[position]).quantity,duplicatePurchases[position]["itemname"]);
                                    },
                                  ),
                                ),
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
      
       duplicatePurchases = res;
     
       
     });
     }
     else if(res== null && query.isNotEmpty ){ setState(() {
      
       duplicatePurchases= [];
     
       
     });
     }
    
    
   }

   else{

     print("hey");
      setState(() {
       
       duplicatePurchases=purchases;
       
     });
   }

  }
 

  loadAsyncData() async {
    var db = new DatabaseHelper();
    List updateditems = await db.getAllPurchases();
    return updateditems;
  }
}
