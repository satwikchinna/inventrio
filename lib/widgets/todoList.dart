import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:inventrio/widgets/addItem.dart';
import '../main.dart';
import '../models/itemModel.dart';
import '../database_helper.dart';
import '../models/todoModel.dart';

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

  Future<void> createTodo(String content) async {
    await db.saveTodo(new Todo(DateTime.now().toIso8601String(), content));
  }

  Future<void> deleteTodo(int id) async {
    await db.deleteTodo(id);
    _getRecords();
  }
  
showAlertDialog(BuildContext context) {  
  // Create button  
  Widget okButton = FlatButton(  
    child: Text("OK"),  
    onPressed: () {
      if(editingController.text.trim() != ""){
      createTodo(editingController.text);
      editingController.clear();
    Navigator.of(context, rootNavigator: true).pop();
      _getRecords();
      }  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Enter Remainder"),  
    content: TextField(
                  controller: editingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                        fillColor: Colors.blue,
                        focusColor: Colors.blue,
                        prefixIcon: Icon(Icons.note_add),
                      labelText: "TODO",
                      )),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: ( context) {  
      return alert;  
    },  
  );  
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
              actions: <Widget>[],
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              child: Icon(Icons.add),
              onPressed: () {
               showAlertDialog(context);
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
                        itemCount: todos.length,
                        itemBuilder: (_, int position) {
                          return new Card(
                              color: Colors.lightBlueAccent,
                              borderOnForeground: true,
                              child: new ListTile(
                                title: new Text(
                                    "${Todo.fromMap(todos[position]).remainder}"
                                        .toUpperCase()),
                                subtitle: new Text(
                                    "Created On: ${Todo.fromMap(todos[position]).time.substring(0, 10)} ${Todo.fromMap(todos[position]).time.substring(11, 16)}"),
                                trailing: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.red,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      deleteTodo(Todo.fromMap(todos[position]).remainderid);
                                    },
                                  ),
                                ),
                              ));
                        }))
              ]),
            )))));
  }
}
