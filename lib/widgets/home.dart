import 'package:flutter/material.dart';
import '../widgets/purchase.dart';
import '../widgets/sale.dart';
import '../widgets/inventory.dart';
import '../widgets/dashboard.dart';
import '../models/itemModel.dart';
import '../database_helper.dart';

class Home extends StatelessWidget {
 final List items;

  // This widget is the root of your application.
Home({Key key, @required this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (Material(
        color: Colors.white,
        child: Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Inventory(items: items)),
                              );
                            },
                            child: Text("INVENTORY",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.lightBlueAccent,
                            disabledColor: Colors.red,
                            
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.black)),
                            elevation: 50,
                          ),
                          SizedBox(width: 15),
                          RaisedButton(
                            onPressed:() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Purchase()),
                              );
                            },
                            child: Text("PURCHASE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.lightBlueAccent,
                            disabledColor: Colors.red,
                            
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.black)),
                            elevation: 50,
                          ),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          RaisedButton(
                            onPressed:() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()),
                              );
                            },
                            child: Text("DASHBOARD",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.lightBlueAccent,
                            disabledColor: Colors.lightBlueAccent,
                            
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.black)),
                            elevation: 50,
                          ),
                          SizedBox(width: 15),
                          RaisedButton(
                            onPressed: ()  {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Sale()),
                              );
                            },
                            child: Text("SALE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.lightBlueAccent,
                            disabledColor: Colors.red,
                          
                            padding: const EdgeInsets.all(10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.black)),
                            elevation: 50,
                          ),
                        ],
                      ))
                ],
              ),
            ))));
  }
}
