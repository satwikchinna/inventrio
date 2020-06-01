import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  TextEditingController tpaController;
  TextEditingController cpaController;

   @override
   void initState() { 
     super.initState();
     setSettings();
   }
   
   void setSettings() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     tpaController = new TextEditingController(text : prefs.getString('TPA'));
     cpaController = new TextEditingController(text : prefs.getString('CPA'));
     
   }

   Future<void> setting() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   if(tpaController.text != "" && cpaController.text != ""){
     prefs.setString('TPA', tpaController.text);
     prefs.setString('CPA', cpaController.text);
   }

  }

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
        title: "INVENTRIO",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Text("SETTINGS"),
              backgroundColor: Colors.lightBlue,
              actions: <Widget>[],
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.black54,
              backgroundColor: Colors.red,
              child: Icon(Icons.check),
              onPressed: () {
                 setting();
              },
            ),
            body: Material(
                child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                SizedBox(height: 10),
                TextField(
                  controller: tpaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.timer),
                      labelText: "Time period for advice",
                      )),  SizedBox(height: 10),
                  
                  TextField(
                  
                  controller: cpaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.timer),
                      labelText: "Cutoff period",
                      )),
              ]),
            ))))
      
    );
  }
}