import 'dart:async';
import 'package:flutter/material.dart';
import '../database_helper.dart';

class DataSearch extends SearchDelegate<String> {
DataSearch(){
  getcities();
}
  var db = DatabaseHelper();

List cities;
var recentCities;

getcities() async{
  cities = await db.getAllItemnames();
 recentCities = ['sugar'];
  }
 

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 100,
        child: Card(
          color: Colors.red,
          child: Center(child: Text("Please select the itemname to purchase it ")),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          itemnamefetch(context,suggestionList[index]);
                  },
                  leading: Icon(Icons.location_city),
                  title: RichText(
                    text: TextSpan(
                      text: suggestionList[index].substring(0, query.length),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: suggestionList[index].substring(query.length),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount:(suggestionList == null) ? 0: suggestionList.length,
              );
            }
          
            void itemnamefetch(context,substring) {
 close(context, null);
Navigator.push(context, new MaterialPageRoute(builder: (context) => new Addpurchases(suggestion: substring)));

            }
}
class Addpurchases extends StatefulWidget {
  final suggestion;
  Addpurchases({Key key, @required this.suggestion}) : super(key: key);
  
  
  @override
  _AddpurchaseState createState() => new _AddpurchaseState();
}

class _AddpurchaseState extends State<Addpurchases> {
 bool _nvalidate = false;
 bool _qvalidate = false;
 bool _svalidate = false;
TextEditingController _itemnameController = new TextEditingController();
TextEditingController _itemquantityController = new TextEditingController();
TextEditingController _itemcpController = new TextEditingController();

bool saved = false;
  var db = DatabaseHelper();
  @override
  initState() {
    super.initState();
    if(widget.suggestion != null ) {
       setState(() {
     _itemnameController.text =widget.suggestion;
    });
    }
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
              title: Text("ADD PURCHASE"),
              actions: <Widget>[
                 IconButton(
                   autofocus: true,
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              }),
              ],
              backgroundColor: Colors.lightBlue,
            ),
           
            body: Material(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(15),
                  child: Column(children: <Widget>[
                  
                    new Center(
  child:saved == true ? new Text("PURCHASE SUCCESSFUL",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.red,) ) : null
),
                  
              TextField(
                  controller: _itemnameController,
                  enabled: false,
                  
                  decoration: InputDecoration(
                     border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        
                      labelText: "Search for item name in appbar",
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
                  controller: _itemcpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "Purchase price",
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
                           
                             
                           
  _submitHandler() {



if (_itemnameController.text.isEmpty ||
                  _itemnameController.text.isEmpty ||
                  _itemcpController.text.isEmpty ||
                  _itemquantityController.text.isEmpty) {
                setState(() {
                  _itemnameController.text.isEmpty
                      ? _nvalidate = true
                      : _nvalidate = false;
                  _itemquantityController.text.isEmpty
                      ? _qvalidate = true
                      : _qvalidate = false;
                  _itemcpController.text.isEmpty
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

db.savePurchase(_itemnameController.text, DateTime.now().toIso8601String() , double.parse(_itemquantityController.text), double.parse(_itemcpController.text));
_itemnameController.clear();
_itemquantityController.clear();
_itemcpController.clear();
setState(() {
   saved = true;
});
              }


            }

  
}
