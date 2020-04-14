import 'package:flutter/material.dart';

class Inventory extends StatelessWidget {
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
              title: Center(child: Text("INVENTORY")),
              backgroundColor: Colors.lightBlue,
            ),floatingActionButton: FloatingActionButton(
  foregroundColor: Colors.black54,
  backgroundColor: Colors.blue,
  child: Icon(Icons.add),
  onPressed: () { print('Clicked'); },
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
                  ]),
                )))));
  }
}
