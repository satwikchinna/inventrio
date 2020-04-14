import 'package:flutter/material.dart';
import '../widgets/purchase.dart';
import '../widgets/sale.dart';
import '../widgets/inventory.dart';
import '../widgets/dashboard.dart';


class Home extends StatelessWidget {
  // This widget is the root of your application.

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
                                    builder: (context) => Inventory()),
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
