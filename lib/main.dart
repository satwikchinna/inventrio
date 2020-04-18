import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:inventrio/widgets/addItem.dart';
import 'package:inventrio/widgets/dashboard.dart';
import 'package:inventrio/widgets/sale.dart';
import './widgets/home.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


import './models/saleModel.dart';
import './database_helper.dart';

List sales;
void main() async {
  var db = DatabaseHelper();
  var data = await db.getAnalysis();

  print(data);
  runApp(myApp(data: data));
}

class myApp extends StatefulWidget {
  var data;
  myApp({Key key, @required this.data}) : super(key: key);
  @override
  _MyappState createState() => new _MyappState();
}

class _MyappState extends State<myApp> {
  String _scanBarcode;
Future scanBarcodeNormal( BuildContext context) async {
    String barcodeScanRes;

      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
        var db = DatabaseHelper();
    var result = await db.getCodeItems(barcodeScanRes);
       
  }
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        title: "INVENTRIO",
        theme: ThemeData(
            buttonTheme: ButtonThemeData(
          height: 106,
          minWidth: 180,
        )),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Center(child: Text("INVENTRIO")),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              child: Text("SCAN"),
              
              onPressed: () {scanBarcodeNormal(context);},
              backgroundColor: Colors.red,
            ),
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.note_add),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            body: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  "DAY WISE INCOME ANALYSIS",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                    height: 410,
                    child: Container(
                      child: (widget.data.length <= 1)
                          ? Text(
                              "-------------------",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          : Sparkline(
                              data: (widget.data.length == 1)
                                  ? widget.data
                                  : [0.0, 1.0],
                              fillMode: FillMode.below,
                              fillGradient: new LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.lightGreen,
                                    Colors.yellow,
                                    Colors.orange
                                  ]),
                              lineColor: Colors.deepOrangeAccent,
                              pointsMode: PointsMode.all,
                              pointSize: 8.0,
                              pointColor: Colors.black,
                            ),
                      padding: EdgeInsets.all(40),
                    )),
                Home()
              ],
            ))));
  }

 
}
