import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';


class PurchaseAdvice extends StatelessWidget{
 getReport() async{
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text("Hello World"),
        ); // Center
      }));
  final directory = await getApplicationDocumentsDirectory();
  final file = File(directory.path+'example.pdf');
  file.writeAsBytesSync(pdf.save());
 }
  
  @override
  Widget build(BuildContext context) {
   
return (MaterialApp(
        title: "INVENTRIO",
        
        home: Scaffold(
         
            appBar: AppBar(
              centerTitle: true,
              title: Text("Purchase Report"),
              backgroundColor: Colors.lightBlue,
               actions: <Widget>[
    FlatButton(
      textColor: Colors.white,
      onPressed: getReport,
      child:Text('pdf'),
      
      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
    ),
  ],
            ),
        )));
  }
}
  

