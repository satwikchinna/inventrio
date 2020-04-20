import 'package:flutter/material.dart';
import 'package:inventrio/models/itemModel.dart';

import '../database_helper.dart';
import 'inventory.dart';


class addItem extends StatefulWidget{

  var code;
  addItem({Key key, @required this.code}) : super(key: key);



  @override
  _Additem createState() => new _Additem();
}

class _Additem extends State<addItem> {
  List result;
  TextEditingController _itemnameController = new TextEditingController();
  TextEditingController _itemstockController = new TextEditingController();
  TextEditingController _itemspController = new TextEditingController();
  TextEditingController _itemcpController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  TextEditingController _itembarcodeController = new TextEditingController();
  List<String> _itemUOM = ['Kgs', 'Litres', 'Nos']; // Option 2
  String _dropdownValue = "Kgs";
  String newValue;
  bool _validate = false;
bool enabled = true;
 @override
  initState() {
    super.initState();
    checkCode();
    
  }
checkCode(){
  if(widget.code != null){
setState(() {
  enabled = false;
  _itembarcodeController.text = widget.code;
});
  }
}

 
List items;
  List duplicateItems;

 


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
              title: Text("Add item"),
              backgroundColor: Colors.lightBlue,
            ),
            body:SingleChildScrollView(child:Column(
            children: <Widget>[
              SizedBox(height: 10),
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
                      errorText: _validate ? "Please fill a valid value" : null,
                      )), SizedBox(height: 10),
              TextField(
                  controller: _itemstockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "Stock",
                      errorText:
                          _validate ? "Please fill a valid value" : null)), SizedBox(height: 10),
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
                          _validate ? "Please fill a valid value" : null)), SizedBox(height: 10),
              TextField(
                  controller: _itemcpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "Purchase price",
                      errorText:
                          _validate ? "Please fill a valid value" : null)),
             SizedBox(height: 10), TextField(
                  controller: _itembarcodeController,
                  enabled:enabled,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "Item barcode",
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
              ),
               SizedBox(height: 10),

                           RaisedButton(onPressed: _submitHandler,
                                                      padding: EdgeInsets.all(13),
                                                                       color: Colors.blue,
                                                                       child: Text("Submit"),          )
                                       ],
                                     )))));
                             }
                           
                             
                           
void _submitHandler() {

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
                                    _dropdownValue,_itembarcodeController.text);
                                _itemnameController.clear();
                                _itemstockController.clear();
                                _itemcpController.clear();
                                _itemspController.clear();
                                Navigator.pop(context);
                                _validate = false;
                              }
                
                
                
                  }
                
                   Future _submitdataHandler(
      String name, String stock, String sp, String cp, String uom,String barcode) async {
    
    
    var db = new DatabaseHelper();
    if(barcode!=""){
    int idofsaved = await db.saveItem(new Item(name, double.parse(stock),
        uom, double.parse(sp), double.parse(cp),barcode));
         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Inventory(id : idofsaved)),
                              );
    }
    else{
int idofsaved = await db.saveItem(new Item(name, double.parse(stock),
        uom, double.parse(sp), double.parse(cp)));
      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Inventory(id : idofsaved)),
                              );
    }
  }
}
