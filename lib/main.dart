import 'package:flutter/material.dart';
import 'package:inventrio/widgets/addItem.dart';
import 'package:inventrio/widgets/dashboard.dart';
import 'package:inventrio/widgets/login.dart';
import 'package:inventrio/widgets/sale.dart';
import 'package:inventrio/widgets/scanResult.dart';
import 'package:inventrio/widgets/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widgets/home.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import './models/saleModel.dart';
import './database_helper.dart';
import './widgets/purchaseAdvice.dart';
import './widgets/todoList.dart';

List sales;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var db = DatabaseHelper();
  var data = await db.getAnalysis();

  runApp(email == null ? MaterialApp(debugShowCheckedModeBanner: false  ,home:LoginScreen()):myApp( data: data));
}

class myApp extends StatefulWidget {
  var data;
  myApp({Key key, @required this.data}) : super(key: key);
  @override
  _MyappState createState() => new _MyappState();
}

class _MyappState extends State<myApp> {
  var x;
 List<charts.Series> seriesList;
  List incomeList = new List();
  var averageSales;
  @override
  void initState() {
    super.initState();
    getX();
    if(widget.data.length > 0){
      
      
    for (var i = 0; i < x.length; i++) {
      incomeList.add(x[i]["income"]);
    }
    print(incomeList);
    seriesList = loadData();
    averageSales = incomeList.reduce((value, element) => value + element) /
        incomeList.length;}
  }

  getX(){
    setState(() {
      x = widget.data;
    });
  }

 
  String _scanBarcode;
 
  Future scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;

    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#8B0000", "Cancel", true, ScanMode.BARCODE);
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
        
        home: Scaffold(
         
            appBar: AppBar(
              leading: Builder(
                 builder: (context) =>    IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings()),
                                  );
                    },
                  ),),
              centerTitle: true,
              title: Text("INVENTRIO"),
              backgroundColor: Colors.lightBlue,
               actions: <Widget>[
    FlatButton(
      textColor: Colors.white,
      onPressed: () {},
      child:_signout() ,
      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
    ),
  ],
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
              color: Colors.lightBlue,
              shape: CircularNotchedRectangle(),
             elevation: 4,
             notchMargin: 4,
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 Builder(
                 builder: (context) =>    IconButton(
                    icon: Icon(Icons.note_add),
                    onPressed: () {
                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TodoList()),
                                  );
                    },
                  ),),
              Builder(
                 builder: (context) =>   IconButton(
                    icon: Icon(Icons.receipt),
                    onPressed:(){
                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PurchaseAdvice()),
                                  );},
                  ),)
                ],
              ),
            ),
            body: new RefreshIndicator(
                onRefresh: _refreshList,
                child:  SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), 
        child:Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      "DAY WISE INCOME ANALYSIS",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                     ChartDay(data: x,),
                                        Home()
                                      ],
                                    )))),
                          
                            debugShowCheckedModeBanner: false,
                            ));
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
 Future<Null> _refreshList() async{

    
                        var db =DatabaseHelper();
                        List incomeList = new List();
                      var averageSales;
                       var data = await db.getAnalysis();
   if(data.length > 0){
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
                      
                      
                      
   

  barChart() {
    return charts.BarChart(seriesList, animate: true, vertical: true);
  }}
                    }
                    
class ChartDay extends StatefulWidget{

  var data;
  ChartDay({Key key, @required this.data}) : super(key: key);
 @override
  ChartDayState createState() => new ChartDayState();
}
class ChartDayState extends State<ChartDay> {

 var x;
 List<charts.Series> seriesList;
  List incomeList = new List();
  var averageSales;
  @override
  void initState() {
     super.initState();
    if(widget.data.length > 0){x = widget.data;
    for (var i = 0; i < x.length; i++) {
      incomeList.add(x[i]["income"]);
    }
    print(incomeList);
    seriesList = loadData();
    averageSales = incomeList.reduce((value, element) => value + element) /
        incomeList.length;}
        

        
  }
  @override
void didUpdateWidget(ChartDay oldWidget) {
  
if(widget.data.length > 0){x = widget.data;
incomeList = [];
    for (var i = 0; i < x.length; i++) {
      incomeList.add(x[i]["income"]);
    }
    print(incomeList);
    seriesList = loadData();
    averageSales = incomeList.reduce((value, element) => value + element) /
        incomeList.length;}
  super.didUpdateWidget(oldWidget);
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
    return  charts.BarChart(seriesList, animate: true, vertical: true
                   );
  }











  @override
  Widget build(BuildContext context) {
    return SizedBox(
                        height: (MediaQuery.of(context).size.height*40)/100,
                        child: Container(
                          child: (widget.data.length > 0) ?barChart() : Text("--------------"),
                          padding: EdgeInsets.all(40),
                        ));
  }
  
}

class Salesdata {
  String date;
  double sales;
  Salesdata(this.date, this.sales);
}
class SizeConfig {
 static MediaQueryData _mediaQueryData;
 static double screenWidth;
 static double screenHeight;
 static double blockSizeHorizontal;
 static double blockSizeVertical;
 
 void init(BuildContext context) {
  _mediaQueryData = MediaQuery.of(context);
  screenWidth = _mediaQueryData.size.width;
  screenHeight = _mediaQueryData.size.height;
  blockSizeHorizontal = screenWidth / 100;
  blockSizeVertical = screenHeight / 100;
 }
}
 Widget _signout() {
return Builder(
                builder: (context) =>IconButton(icon: Icon(Icons.power_settings_new),onPressed:()async{
 SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('email');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));

        
      }));
      
      
      }