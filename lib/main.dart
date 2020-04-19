import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:inventrio/widgets/addItem.dart';
import 'package:inventrio/widgets/dashboard.dart';
import 'package:inventrio/widgets/sale.dart';
import 'package:inventrio/widgets/scanResult.dart';
import './widgets/home.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import './models/saleModel.dart';
import './database_helper.dart';

List sales;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = DatabaseHelper();
  var data = await db.getAnalysis();

  runApp(myApp(data: data));
}

class myApp extends StatefulWidget {
  var data;
  myApp({Key key, @required this.data}) : super(key: key);
  @override
  _MyappState createState() => new _MyappState();
}

class _MyappState extends State<myApp> {
  var x;

  List incomeList = new List();
  var averageSales;
  @override
  void initState() {
    if(widget.data.length > 0){x = widget.data;
    for (var i = 0; i < x.length; i++) {
      incomeList.add(x[i]["income"]);
    }
    print(incomeList);
    seriesList = loadData();
    averageSales = incomeList.reduce((value, element) => value + element) /
        incomeList.length;}
  }

  List<charts.Series<Salesdata, String>> loadData() {
    List<Salesdata> mobileSalesdata = [];
    for (var i = 0; i < x.length; i++) {
      mobileSalesdata.add(new Salesdata(x[i]['day'], x[i]["income"]));
    }
    return [
      charts.Series<Salesdata, String>(
        data: mobileSalesdata,
        id: 'Sales',
        domainFn: (Salesdata sales, _) => sales.date,
        measureFn: (Salesdata sales, _) => sales.sales,
        colorFn: (Salesdata sales, _) {
          return (sales.sales >= averageSales)
              ? charts.MaterialPalette.green.shadeDefault
              : charts.MaterialPalette.deepOrange.shadeDefault;
        },
      )
    ];
  }

  barChart() {
    return charts.BarChart(seriesList, animate: true, vertical: true);
  }

  String _scanBarcode;
  List<charts.Series> seriesList;
  Future scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;

    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    var db = DatabaseHelper();
    if (barcodeScanRes != "-1") {
      var result = await db.getCodeItems(barcodeScanRes);

      if (result != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => scanResult(result: result)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => addItem(code: barcodeScanRes)),
        );
      }
    }
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
            floatingActionButton: Builder(
                builder: (context) => FloatingActionButton(
                      child: Text("SCAN"),
                      onPressed: () {
                        scanBarcodeNormal(context);
                      },
                      backgroundColor: Colors.red,
                    )),
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
            body: new RefreshIndicator(
                onRefresh: _refreshList,
                child:  SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), 
        child:Column(
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
                          child: (widget.data.length > 0) ?barChart() : Text("--------------"),
                          padding: EdgeInsets.all(40),
                        )),
                    Home()
                  ],
                ))))));
  }

  Future<Null> _refreshList() async{
    var db =DatabaseHelper();
    List incomeList = new List();
  var averageSales;
   var data = await db.getAnalysis();
   setState(() {
     x = data;
   });
    seriesList = loadData();
    setState(() {
     seriesList = seriesList;
   });
     for (var i = 0; i < x.length; i++) {
      incomeList.add(x[i]["income"]);
    }
    print(incomeList);
    averageSales = incomeList.reduce((value, element) => value + element) /
        incomeList.length;
setState(() {
     averageSales = averageSales;
   });
      
    
        
  }
}

class Salesdata {
  String date;
  double sales;
  Salesdata(this.date, this.sales);
}
