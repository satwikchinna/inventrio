import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static String tpa;
  static String cpa;
  TextEditingController tpaController = TextEditingController();
  TextEditingController cpaController = TextEditingController();

   @override
   void initState() { 
     super.initState();
     setSettings();
   }
   
   void setSettings() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
      tpa=prefs.getString('TPA');
      cpa=prefs.getString('CPA');
      setState(() {
        tpaController.text=tpa;
        cpaController.text=cpa;
      });
     
   }

   Future<void> setting(String tpa,String cpa) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   if(tpa != "" && cpa != ""){
     prefs.setString('TPA', tpa);
     prefs.setString('CPA', cpa);
     Navigator.of(context).pop();
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
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              child: Icon(Icons.check),
              onPressed: () {
                 setting(tpaController.text,cpaController.text);
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