import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import '../models/itemModel.dart';
import '../database_helper.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => new _InventoryState();
}

class _InventoryState extends State<Inventory> {
  TextEditingController _itemnameController = new TextEditingController();
  TextEditingController _itemstockController = new TextEditingController();
  TextEditingController _itemspController = new TextEditingController();
  TextEditingController _itemcpController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  List<String> _itemUOM = ['Kgs', 'Litres', 'Nos']; // Option 2
  String _dropdownValue = "Kgs";
  String newValue;
  List items;
  List duplicateItems;

  bool _validate = false;
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

  void _showDialog() {
    var alert = AlertDialog(
      content: StatefulBuilder(
        // You need this, notice the parameters below:
        builder: (BuildContext context, StateSetter setState) {
          return (Column(
            children: <Widget>[
              TextField(
                  controller: _itemnameController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Item name",
                      hintText: "Sugar",
                      errorText: _validate ? "Please fill a valid value" : null,
                      icon: Icon(Icons.note_add))),
              TextField(
                  controller: _itemstockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Stock",
                      errorText:
                          _validate ? "Please fill a valid value" : null)),
              TextField(
                  controller: _itemspController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Selling price",
                      errorText:
                          _validate ? "Please fill a valid value" : null)),
              TextField(
                  controller: _itemcpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Purchase price",
                      errorText:
                          _validate ? "Please fill a valid value" : null)),
              DropdownButton<String>(
                // Not necessary for Option 1
                value: _dropdownValue,
                onChanged: (newValue) {
                  setState(() {
                    _dropdownValue = newValue;
                  });
                },
                items: _itemUOM.map((location) {
                  return DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
              )
            ],
          ));
        },
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (_itemnameController.text.isEmpty ||
                  _itemstockController.text.isEmpty ||
                  _itemspController.text.isEmpty ||
                  _itemcpController.text.isEmpty) {
                setState(() {
                  _itemnameController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                  _itemstockController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                  _itemspController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                  _itemcpController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
              } else {
                _submitdataHandler(
                    _itemnameController.text,
                    _itemstockController.text,
                    _itemspController.text,
                    _itemcpController.text,
                    _dropdownValue);
                _itemnameController.clear();
                _itemstockController.clear();
                _itemcpController.clear();
                _itemspController.clear();
                Navigator.pop(context);
                _validate = false;
              }
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () {
              _validate = false;
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return (Center(
            // Aligns the container to center

            child: Container(
              // A simplified version of dialog.
              width: 500,
              height: 454,

              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[alert],
                ),
              ),
            ),
          ));
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
              title: Text("INVENTORY"),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.black54,
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
              onPressed: _showDialog,
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
                                        "Stock: ${Item.fromMap(duplicateItems[position]).itemstock}"),
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
     
     setState(() {
      
       duplicateItems = res;
     
       
     });
    
   }
   else{
      setState(() {
       
       duplicateItems = items;
       duplicateItems.removeWhere((value) => value == null);
     });
   }
  }

  Future _submitdataHandler(
      String name, String stock, String sp, String cp, String uom) async {
    int measure;
    if (uom == 'kgs') {
      measure = 1;
    } else if (uom == 'Nos') {
      measure = 2;
    } else {
      measure = 3;
    }
    var db = new DatabaseHelper();
    int idofsaved = await db.saveItem(new Item(name, double.parse(stock),
        measure, double.parse(sp), double.parse(cp)));
    dynamic updateditems = await db.getItem(idofsaved);
    setState(() {
      duplicateItems.insert(0, updateditems);
    });
  }

  loadAsyncData() async {
    var db = new DatabaseHelper();
    List updateditems = await db.getAllItems();
    return updateditems;
  }
}
