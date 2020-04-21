import 'package:flutter/material.dart';
import 'package:inventrio/database_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Dashboard extends StatefulWidget{
  @override
  _dashboard createState() => new _dashboard();
}

class _dashboard extends State<Dashboard> {
List<dynamic> monthlyIncomes;
List<dynamic> monthlyPurchases;
String topsellingItem;
String highlyprofitableItem;

@override
void initState(){
  super.initState();
getdashboaardDetails();
 
  }

  


  void getdashboaardDetails() async{
var db = DatabaseHelper();
monthlyIncomes = await db.gettotalmIncomes();
monthlyPurchases = await db.gettotalmPurchases();
var x = await db.gethiglySelling();
var y = await db.gethiglyProfitable();
setState(() {
  monthlyIncomes =monthlyIncomes;
  monthlyPurchases= monthlyPurchases;
  if(x.length != 0){
  topsellingItem = x.first["hitem"];}
 if(y.length!=0){ highlyprofitableItem = y.first["pitem"];}
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
         backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Text("DASHBOARD"),
              backgroundColor: Colors.lightBlue,
            ),
            
            
            body: new RefreshIndicator(
                onRefresh: _refreshList,
                child:  SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), 
        child:Container(
              padding: EdgeInsets.all(20),
              child: Column(
              children:  <Widget>[

              (!["", null, false, 0].contains(highlyprofitableItem))?Text(highlyprofitableItem.toUpperCase() +" is highly profitable item in this store", style: TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      fontFamily: 'Open Sans',
      fontSize: 25),):Text("")
      ,
     Container(
  margin: const EdgeInsets.all(15.0),
  padding: const EdgeInsets.all(3.0),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blueAccent)
  ),
  child:Column(children:<Widget>[Text(
                      "MONTHLY INCOME ANALYSIS",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),  (!["", null, false, 0].contains(monthlyIncomes))?ChartDay(data:monthlyIncomes):Text("----------"),])),
      (!["", null, false, 0].contains(topsellingItem))?Text(topsellingItem.toUpperCase() +" is top selling item in this store", style: TextStyle(
      color: Colors.orange,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      fontFamily: 'Open Sans',
      fontSize: 25),):Text(""),
  Container(
  margin: const EdgeInsets.all(15.0),
  padding: const EdgeInsets.all(3.0),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.blueAccent)
  ),
  child:Column(children:<Widget>[Text(
                      "MONTHLY INVESTMENT ANALYSIS",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),            
(!["", null, false, 0].contains(monthlyIncomes))? ChartDay(data:monthlyPurchases):Text("----------"),]))

              ]
            )))))));
            
  }
  

            
 Future<Null> _refreshList() async{

  var db = DatabaseHelper();
  monthlyIncomes = await db.gettotalmIncomes();
  setState(() {
    monthlyIncomes = monthlyIncomes;
  });
                      
                    
                      
                      
 }
            
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
    if(!widget.data.isEmpty){
      x = widget.data;
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
  
if(!widget.data.isEmpty){x = widget.data;
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
    return Expanded(child:charts.BarChart(seriesList, animate: true, vertical: true, behaviors: [
                   new charts.SlidingViewport(),
                   new charts.PanAndZoomBehavior(),
                   ]));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                        height: (MediaQuery.of(context).size.height*40)/100,
                        child: Container(
                          child: (!["", null, false, 0].contains(widget.data) ?barChart() : Text("--------------")),
                          padding: EdgeInsets.all(40),
                        ));
  }
  
}

class Salesdata {
  String date;
  double sales;
  Salesdata(this.date, this.sales);
}