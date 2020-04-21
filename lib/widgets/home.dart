import 'package:flutter/material.dart';
import '../widgets/purchase.dart';
import '../widgets/sale.dart';
import '../widgets/inventory.dart';
import '../widgets/dashboard.dart';
import '../models/itemModel.dart';
import '../database_helper.dart';

class Home extends StatelessWidget {
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Inventory(id: null),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return (Material(
        child: Container(
            alignment: Alignment.center,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          left:(MediaQuery.of(context).size.width * 4.5) / 100,
                          top:(MediaQuery.of(context).size.width * 5) / 100,
                          bottom:(MediaQuery.of(context).size.width * 4.5) / 100),
                      child: Row(
                        children: <Widget>[
                          new SizedBox(
                              width: (MediaQuery.of(context).size.width * 44) /
                                  100,
                              height:
                                  (MediaQuery.of(context).size.height * 13) /
                                      100,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).push(_createRoute());
                                },
                                child: Text("INVENTORY",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                color: Colors.lightBlueAccent,
                                disabledColor: Colors.red,
                                padding: EdgeInsets.all(
                                    (MediaQuery.of(context).size.width * 3) /
                                        100),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)),
                                elevation: 6,
                              )),
                          SizedBox(
                              width: (MediaQuery.of(context).size.width * 2) /
                                  100),
                          SizedBox(
                              width: (MediaQuery.of(context).size.width * 44) /
                                  100,
                              height:
                                  (MediaQuery.of(context).size.height * 13) /
                                      100,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Purchases()),
                                  );
                                },
                                child: Text("PURCHASE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                color: Colors.lightBlueAccent,
                                disabledColor: Colors.red,
                                padding: EdgeInsets.all(
                                    (MediaQuery.of(context).size.width * 3) /
                                        100),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)),
                                elevation: 6,
                              )),
                        ],
                      )),
                  Container(
                     alignment: Alignment.center,
                      padding: EdgeInsets.only(
                       left:   (MediaQuery.of(context).size.width *4.5 ) / 100,
                       bottom: (MediaQuery.of(context).size.width *4.5 ) / 100),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                              width: (MediaQuery.of(context).size.width * 44) /
                                  100,
                              height:
                                  (MediaQuery.of(context).size.height * 13) /
                                      100,
                              child: RaisedButton(
                                onPressed: () async{
var db = DatabaseHelper();
                                  final snackBar = SnackBar(content: Text('Please perform more transactions to unlock dashboard!'));
var data1 = await db.gettotalmIncomes();
var data2 = await db.gettotalmPurchases();
if(data1.length != 0 && data2.length != 0){
  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()),
                                  );
}
else{
  Scaffold.of(context).showSnackBar(snackBar);
}
                                
                                },
                                child: Text("DASHBOARD",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                color: Colors.lightBlueAccent,
                                disabledColor: Colors.lightBlueAccent,
                                padding: EdgeInsets.all(
                                    (MediaQuery.of(context).size.width * 2) /
                                        100),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)),
                                elevation: 6,
                              )),
                          SizedBox(
                              width: (MediaQuery.of(context).size.width * 2) /
                                  100),
                          SizedBox(
                              width: (MediaQuery.of(context).size.width * 44) /
                                  100,
                              height:
                                  (MediaQuery.of(context).size.height * 13) /
                                      100,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Sales()),
                                  );
                                },
                                child: Text("SALE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                color: Colors.lightBlueAccent,
                                disabledColor: Colors.red,
                                padding:  EdgeInsets.all(
                                    (MediaQuery.of(context).size.width * 2) /
                                        100),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black)),
                                elevation: 8,
                              )),
                        ],
                      ))
                ],
              ),
            ))));
  }
}
