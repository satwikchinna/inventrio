import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../database_helper.dart';

class PurchaseAdvice extends StatefulWidget {
  @override
  _PurchaseAdviceState createState() => _PurchaseAdviceState();
}

class _PurchaseAdviceState extends State<PurchaseAdvice> {
  var advice = [];

  @override
  void initState() {
    super.initState();
    getAdvice();
  }

  getAdvice() async {
    var db = DatabaseHelper();
    advice = await db.getAdvice();
    setState(() {
      advice = advice;
    });
  }
showSnackbar(BuildContext context){
   final snackBar = SnackBar(content: Text('Purchase advice has been saved to device!'));
  return Scaffold.of(context).showSnackBar(snackBar);
}
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        title: "INVENTRIO",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Text("Purchase Advice"),
              backgroundColor: Colors.lightBlue,
            ),
            floatingActionButton: Builder(
        builder: (context) =>FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              child: Icon(Icons.arrow_downward),
              onPressed: () async {
                getReport(advice);
                showSnackbar(context);
                
                
                
              },
            )),
            body: Material(
                child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: advice.length,
                        itemBuilder: (_, int position) {
                          if (advice[position]['advice'] < 0) {
                            return null;
                          } else {
                            return new Card(
                                color: Colors.green,
                                borderOnForeground: true,
                                child: new ListTile(
                                  title: new Text("${advice[position]['item']}"
                                      .toUpperCase()),
                                  trailing: (advice[position]['uom'] != 'Nos')
                                      ? new Text(
                                          "ADVICE:${advice[position]['advice'].toStringAsFixed(1)}  ${advice[position]['uom']}")
                                      : new Text(
                                          "ADVICE:${advice[position]['advice'].toStringAsFixed(0)}  ${advice[position]['uom']}"),
                                  subtitle: new Text(
                                      "Current Stock:${advice[position]['stock']}"),
                                ));
                          }
                        })),
              ]),
            )))));
  }
}

getReport(advice) async {
  final pdf = pw.Document(
    title: 'Purchase Advice by Inventrio',
  );
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
      return  pw.FullPage(ignoreMargins: false,child: pw.Column(children: <pw.Widget>[
          pw.Header(text: "Purchase Advice by INVENTRIO               ${DateTime.now().toIso8601String().substring(0,10)}"),
          pw.Column(children:PdfWidgets(advice) ) ,
          
        ]));
      }));
  final directory = await getExternalStorageDirectory();
  File(directory.path + '/Purchase-advice ${DateTime.now().toIso8601String().substring(0,10)}.pdf').writeAsBytesSync(pdf.save());

}

List<pw.Widget> PdfWidgets(advice) {
List<pw.Widget> list = new List();
for(var i=0;i<advice.length;i++){
 if(advice[i]['advice'] > 0){

if(advice[i]['uom'] != 'Nos'){
list.add(new pw.Text("${advice[i]['item']}  :  ${advice[i]['advice'].toStringAsFixed(1)}  ${advice[i]['uom']} "
                                      .toUpperCase(),style: new pw.TextStyle( fontWeight: pw.FontWeight.bold,height: 10, fontSize: 14)));

  }
else{
  list.add(new pw.Text("${advice[i]['item']}  :  ${advice[i]['advice'].toStringAsFixed(0)}  ${advice[i]['uom']} "
                                      .toUpperCase(),style: new pw.TextStyle(fontWeight: pw.FontWeight.bold,height: 10, fontSize: 14)));
}


 } 
  

}
return list;
}