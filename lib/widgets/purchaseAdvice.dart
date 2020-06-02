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
  var advice=[];

  @override
  void initState() {
    super.initState();
    getAdvice();
  }

  getAdvice() async {
    var db = DatabaseHelper();
    advice = await db.getAdvice();
    setState(() {
      advice=advice;
    });
   
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
              title: Text("Purchase Report"),
              backgroundColor: Colors.lightBlue,
             
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              child: Icon(Icons.arrow_downward),
              onPressed: () async{
              getReport();
              },
            ),
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
                          return new Card(
                              color: Colors.green,
                              borderOnForeground: true,
                              child: new ListTile(
                                title: new Text("${advice[position]['item']}"
                                    .toUpperCase()),
                                trailing:(advice[position]['uom'] != 'Nos') ? new Text(
                                    "ADVICE:${advice[position]['advice'].toStringAsFixed(1)}"):new Text(
                                    "ADVICE:${advice[position]['advice'].toStringAsFixed(0)}"),
                                subtitle: new Text(
                                    "Current Stock:${advice[position]['stock']}") ,
                              ));
                        })),
              ]),
            )))));
  }
}

getReport() async {
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text("Hello World"),
        ); // Center
      }));
  final directory = await getApplicationDocumentsDirectory();
  final file = File(directory.path + 'example.pdf');
  file.writeAsBytesSync(pdf.save());
  
}
