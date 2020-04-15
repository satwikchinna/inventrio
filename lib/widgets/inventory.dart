import 'package:flutter/material.dart';
import 'package:async/async.dart';
import '../models/itemModel.dart';
import '../database_helper.dart';

class Inventory extends StatefulWidget {
  List items;
  Inventory({Key key, this.items}) : super(key: key);

  @override
  _InventoryState createState() => new _InventoryState();
}

class _InventoryState extends State<Inventory> {
  TextEditingController _itemnameController = new TextEditingController();
  TextEditingController _itemstockController = new TextEditingController();
  TextEditingController _itemspController = new TextEditingController();
  TextEditingController _itemcpController = new TextEditingController();
  String dropdownValue ="Kgs" ;

  

  void _showDialog() {
    
    var alert = new AlertDialog(
      content: Column(
        children: <Widget>[
          TextField(
              controller: _itemnameController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item name",
                  hintText: "Sugar",
                  icon: Icon(Icons.note_add))),
          TextField(
              controller: _itemstockController,
              decoration: InputDecoration(
                labelText: "Stock",
              )),
          TextField(
              controller: _itemspController,
              decoration: InputDecoration(
                labelText: "Selling price",
              )),
          TextField(
              controller: _itemcpController,
              decoration: InputDecoration(
                labelText: "Purchase price",
              )),
          DropdownButton<String>(
             items: <String>['Kgs', 'Litres', 'Nos']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.grey,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
           
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _submitdataHandler(
                  _itemnameController.text,
                  _itemstockController.text,
                  _itemspController.text,
                  _itemcpController.text,
                  dropdownValue);
              _itemnameController.clear();
              _itemstockController.clear();
              _itemcpController.clear();
              _itemspController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () {
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
              backgroundColor: Colors.yellow,
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
                            itemCount: widget.items.length,
                            itemBuilder: (_, int position) {
                              return new Card(
                                  color: Colors.white,
                                  elevation: 2.0,
                                  child: new ListTile(
                                    leading: CircleAvatar(
                                      child: new Text(
                                          "${Item.fromMap(widget.items[position]).itemname}"
                                              .substring(0, 1)),
                                    ),
                                    title: new Text(
                                        "${Item.fromMap(widget.items[position]).itemname}"
                                            .toUpperCase()),
                                    subtitle: new Text(
                                        "Stock: ${Item.fromMap(widget.items[position]).itemstock}"),
                                    trailing: new Text(
                                        "Price:${Item.fromMap(widget.items[position]).sellingprice}"),
                                  ));
                            }))
                  ]),
                )))));
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
    db.saveItem(new Item(name, double.parse(stock), measure, double.parse(sp),
        double.parse(cp)));
    List updateditems = await db.getAllItems();
    setState(() {
      widget.items = updateditems;
    });
  }
}


