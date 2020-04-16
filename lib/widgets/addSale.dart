import 'dart:async';
import 'package:flutter/material.dart';
import '../database_helper.dart';

class Addsales extends StatefulWidget {
  @override
  _AddsaleState createState() => new _AddsaleState();
}

class _AddsaleState extends State<Addsales> {
 bool _nvalidate = false;
 bool _qvalidate = false;
 bool _svalidate = false;
TextEditingController _itemnameController = new TextEditingController();
TextEditingController _itemquantityController = new TextEditingController();
TextEditingController _itemspController = new TextEditingController();


  var db = DatabaseHelper();
  @override
  initState() {
    super.initState();
    _getRecords();
  }
List items;
List duplicateItems;
  Future<void> _getRecords() async {
    var res = await db.getAllItems();

    setState(() {
      items = res;
      duplicateItems = items;
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
              title: Text("ADD SALE"),
              backgroundColor: Colors.lightBlue,
            ),
           
            body: Material(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(15),
                  child: Column(children: <Widget>[
                    
              TextField(
                  controller: _itemnameController,
                  autofocus: true,
                  decoration: InputDecoration(
                     border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "Item name",
                      hintText: "Sugar",
                      errorText: _nvalidate ? "Please fill a valid value" : null,
                     )),
                      SizedBox(height: 10),
              TextField(
                
                  controller: _itemquantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "Quantity",
                      errorText:
                          _qvalidate ? "Please fill a valid value" : null)),
                           SizedBox(height: 10),
              TextField(
                  controller: _itemspController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "Selling price",
                      errorText:
                          _svalidate ? "Please fill a valid value" : null)),
                           SizedBox(height: 10),

                           RaisedButton(onPressed: _submitHandler,
                           padding: EdgeInsets.all(13),
                                            color: Colors.blue,
                                            child: Text("Submit"),          )
                                         
                                             ]),
                                           )))));
                             }
                           
                             
                           
 void _submitHandler() {



if (_itemnameController.text.isEmpty ||
                  _itemnameController.text.isEmpty ||
                  _itemspController.text.isEmpty ||
                  _itemquantityController.text.isEmpty) {
                setState(() {
                  _itemnameController.text.isEmpty
                      ? _nvalidate = true
                      : _nvalidate = false;
                  _itemquantityController.text.isEmpty
                      ? _qvalidate = true
                      : _qvalidate = false;
                  _itemspController.text.isEmpty
                      ? _svalidate = true
                      : _svalidate = false;
                  
                });
              }
               else {
               setState(() {
                _svalidate = false;
                _qvalidate = false;
                _nvalidate = false;
               });
              }
            }

  
}
