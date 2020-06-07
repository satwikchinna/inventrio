import 'package:flutter/material.dart';
import 'package:inventrio/models/itemModel.dart';

import '../database_helper.dart';
import '../main.dart';
import 'inventory.dart';


class scanResult extends StatefulWidget{

  var result;
  scanResult({Key key, @required this.result}) : super(key: key);



  @override
  _scanResult createState() => new _scanResult();
}

class _scanResult extends State<scanResult> {
  List result;
  TextEditingController _itemnameController = new TextEditingController();
  TextEditingController _itemstockController = new TextEditingController();
  TextEditingController _itemspController = new TextEditingController();
  TextEditingController _itemquantityController = new TextEditingController();
  TextEditingController editingController = new TextEditingController();
  bool _validate = false;
bool enabled = true;
 @override
  initState() {
    super.initState();
    checkCode();
    
  }
checkCode(){
  if(widget.result != null){
setState(() {
  enabled = false;
  _itemnameController.text = widget.result['itemname'];
  _itemstockController.text = (widget.result['itemstock']).toString();
  _itemnameController.text = widget.result['itemname'];

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
          height: 80,
          minWidth: 120,
        )),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("Sell or Purchase item"),
              backgroundColor: Colors.lightBlue,
            ),
            body:SingleChildScrollView(child:Column(
            children: <Widget>[
              SizedBox(height: 10),
              TextField(
                  controller: _itemnameController,
                  
                  enabled: enabled,
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
                enabled: enabled,
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
                      labelText: "Price",
                      errorText:
                          _validate ? "Please fill a valid value" : null)), SizedBox(height: 10),
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
                          _validate ? "Please fill a valid value" : null)),
             
               SizedBox(height: 10),
Center(child:Column(children: <Widget>[ RaisedButton(onPressed: _submitHandler,
                                                      padding: EdgeInsets.all(25),
                                                      
                                                                       color: Colors.blue,
                                                                       child: Text("Sell"),          ),
                                                                       SizedBox(height: 20), RaisedButton(onPressed: _purchaseoHandler,
                                                      padding: EdgeInsets.all(25),
                                                                       color: Colors.blue,
                                                                       child: Text("Purchase"),          )],))
                          
                                       ],
                                     )))));
                             }
                           
                             
                           
void _submitHandler() {

 if (_itemnameController.text.isEmpty ||
                  _itemstockController.text.isEmpty ||
                  _itemspController.text.isEmpty ||
                  _itemquantityController.text.isEmpty) {
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
                  _itemquantityController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
              } else {
                _submitdataHandler(
                                    _itemnameController.text,
                                    _itemstockController.text,
                                    
                                    _itemquantityController.text,
                                    _itemspController.text,
                                    );
                                _itemnameController.clear();
                                _itemstockController.clear();
                                _itemquantityController.clear();
                                _itemspController.clear();
                                Navigator.pop(context);
                                _validate = false;
                              }
                
                
                
                  }

 void _purchaseoHandler() {

 if (_itemnameController.text.isEmpty ||
                  _itemstockController.text.isEmpty ||
                  _itemspController.text.isEmpty ||
                  _itemquantityController.text.isEmpty) {
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
                  _itemquantityController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
              } else {
                _purchaseHandler(
                                    _itemnameController.text,
                                    _itemstockController.text,
                                    
                                    _itemquantityController.text,
                                    _itemspController.text,
                                    );
                                _itemnameController.clear();
                                _itemstockController.clear();
                                _itemquantityController.clear();
                                _itemspController.clear();
                                Navigator.pop(context);
                                _validate = false;
                              }
                
                
                
                  }
                
                
Future _submitdataHandler(
      String name, String stock, String quant, String sp) async {
    
    
    var db = new DatabaseHelper();
   
   db.saveSale(name,DateTime.now().toIso8601String(),double.parse(quant),double.parse(sp));
    var data = await db.getAnalysis();
   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myApp(data:data)),
                              );
    
   
    
  }

Future _purchaseHandler(

      String name, String stock, String quant, String sp) async {
    
    
    var db = new DatabaseHelper();
   
   db.savePurchase(name,DateTime.now().toIso8601String(),double.parse(quant),double.parse(sp));
    var data = await db.getAnalysis();
   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myApp(data:data)),
                              );
    
   
    
  }

}
