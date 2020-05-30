import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:inventrio/widgets/addItem.dart';
import '../main.dart';
import '../models/itemModel.dart';
import '../database_helper.dart';

class TodoList extends StatefulWidget {

  @override
  TodoState createState() => new TodoState();
}

class TodoState extends State<TodoList> {

  TextEditingController editingController = new TextEditingController();
  List todos;

  var db = DatabaseHelper();
  @override
  initState() {
    super.initState();
    _getRecords();
  }

  Future<void> _getRecords() async {
    var res = await db.getAllTodos();

    setState(() {
      todos = res;
    });
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
              title: Text("TODO"),
              backgroundColor: Colors.lightBlue,
               actions: <Widget>[
  ],
            ),
        )));
  }
}
