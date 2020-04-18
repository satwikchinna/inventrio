import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:inventrio/widgets/addItem.dart';
import '../main.dart';
import '../models/itemModel.dart';
import '../database_helper.dart';

class Inventory extends StatefulWidget {

  var id;
  Inventory({Key key, @required this.id}) : super(key: key);
  @override
  _InventoryState createState() => new _InventoryState();
}

class _InventoryState extends State<Inventory> {





  TextEditingController editingController = new TextEditingController();
  List items;
  List duplicateItems;

  var db = DatabaseHelper();
  @override
  initState() {
    super.initState();
    _getRecords();
  }

  Future<void> _getRecords() async {
    var res = await db.getAllItems();

    setState(() {
      items = res;
      duplicateItems = items;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return  
      (MaterialApp(
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
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () async{
                   var db = DatabaseHelper();
  var data = await db.getAnalysis();
  Navigator.pop(context);
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myApp(data:data)),
                              );},
              ),
              title: Text("INVENTORY"),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.black54,
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
              onPressed: (){
                     Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => addItem()),
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
                        labelText: 'Search Inventory',
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: duplicateItems.length,
                            itemBuilder: (_, int position) {
                              return new Card(
                                  color: Colors.lightBlueAccent,
                                  borderOnForeground: true,
                                  child: new ListTile(
                                    leading: CircleAvatar(
                                      child: new Text(
                                          "${Item.fromMap(duplicateItems[position]).itemname}"
                                              .substring(0, 1)),
                                    ),
                                    title: new Text(
                                        "${Item.fromMap(duplicateItems[position]).itemname}"
                                            .toUpperCase()),
                                    subtitle: new Text(
                                        "Stock: ${Item.fromMap(duplicateItems[position]).itemstock} ${Item.fromMap(duplicateItems[position]).uom}"),
                                    trailing: new Text(
                                        "Price:${Item.fromMap(duplicateItems[position]).sellingprice}"),
                                  ));
                            }))
                  ]),
                )))));
  }

  void filterSearchResults(String query) async{
   if(query.isNotEmpty){
     var db = DatabaseHelper();
     var res = await db.getItemsearch(query);
     if(res!= null){
 setState(() {
      
       duplicateItems = res;
     
       
     });
     }
     else if(res== null && query.isNotEmpty ){ setState(() {
      
       duplicateItems= [];
     
       
     });
     }
    
    
   }

   else{

     print("hey");
      setState(() {
       
       duplicateItems=items;
       
     });
   }

  }

  loadAsyncData() async {  

  if(widget.id != null ){

  var db = new DatabaseHelper();
   dynamic updateditems = await db.getItem(widget.id);
    setState(() {
      duplicateItems.insert(0, updateditems);
    });

  }
  
  }
}
