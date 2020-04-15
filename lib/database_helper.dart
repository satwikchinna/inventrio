import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'models/itemModel.dart';

class DatabaseHelper{

 static final itable = 'itemlist';
  static final stable = 'saleslist';
  static final ptable = 'purchaseslist';
  
  static final columnId = '_itemid';
  static final columnName = 'itemname';
  static final columnStock = 'itemstock';
  static final columnUom = 'uom';
  static final columnSp = 'sellingprice';
  static final columnCp = 'costprice';
  static final columnSid = 'saleid';
  static final columnPid = 'purchaseid';
  static final columnQuantity = 'quantity';
  static final columnDate = 'doc';
static final DatabaseHelper _instance = new DatabaseHelper.internal();
factory DatabaseHelper() => _instance;
static Database _db;

Future<Database> get db async{
  if (_db != null){
    return _db;
  }
  _db = await initDb();
  return _db;
  }
    DatabaseHelper.internal();
  
   initDb() async { 
Directory documentDirectory = await getApplicationDocumentsDirectory();
String path = join(documentDirectory.path,"maindb.db");

var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate ) ;
return ourDb;
   }

  void _onCreate( Database db , int newVersion) async {
    await db.execute('''
          CREATE TABLE $itable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnStock REAL NOT NULL,
            $columnUom INTEGER NOT NULL,
            $columnSp REAL NOT NULL,
            $columnCp REAL NOT NULL
          )
          ''');
     await db.execute('''
          CREATE TABLE $stable (
            $columnSid INTEGER PRIMARY KEY,
            $columnId INTEGER NOT NULL,
            $columnQuantity REAL NOT NULL,
            $columnSp REAL NOT NULL,
            $columnDate DEFAULT CURRENT_TIMESTAMP
          )
          ''');
      await db.execute('''
          CREATE TABLE $ptable (
            $columnPid INTEGER PRIMARY KEY,
            $columnId INTEGER NOT NULL,
            $columnQuantity REAL NOT NULL,
            $columnCp REAL NOT NULL,
            $columnDate DEFAULT CURRENT_TIMESTAMP
          )
          ''');


  }
  Future<int> saveItem(Item item) async{
       var dbClient = await db;
       int res = await dbClient.insert("$itable",item.toMap());
       return res;


  }

Future<List> getAllItems() async {

  var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT * FROM $itable ORDER BY $columnId DESC");
  return result.toList();
}


Future<int> getCount() async{
var dbClient = await db;
return Sqflite.firstIntValue(
  await dbClient.rawQuery("SELECT COUNT(*) FROM $itable")
);
}
 

 Future<Item> getItem(int id) async{
   var dbClient = await db;
   var result = await dbClient.rawQuery("SELECT * FROM $itable WHERE $columnId = $id");
   if(result.length == 0) return null;
   return new Item.fromMap(result.first);
 }

 Future<int> updateItem(Item item) async{
   var dbClient = await db;
   return dbClient.update("$itable", item.toMap(),where: "$columnId = ?" ,whereArgs: [item.itemid]);

 }


 Future close() async{
   var dbClient = await db;
   return dbClient.close();

 }
}