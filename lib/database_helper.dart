import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'models/itemModel.dart';
import 'models/saleModel.dart';
import 'models/purchaseModel.dart';

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
String path = join(documentDirectory.path,"maindb1.db");

var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate ) ;
return ourDb;
   }

  void _onCreate( Database db , int newVersion) async {
    await db.execute('''
          CREATE TABLE $itable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnStock REAL NOT NULL,
            $columnUom TEXT NOT NULL,
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
            $columnDate TEXT NOT NULL,
            FOREIGN KEY ($columnId)
       REFERENCES $itable($columnId)
          )
          ''');
      await db.execute('''
          CREATE TABLE $ptable (
            $columnPid INTEGER PRIMARY KEY,
            $columnId INTEGER NOT NULL,
            $columnQuantity REAL NOT NULL,
            $columnCp REAL NOT NULL,
            $columnDate TEXT NOT NULL,
            FOREIGN KEY ($columnId)
       REFERENCES $itable($columnId)
          
          )
          ''');


  }
  Future<int> saveItem(Item item) async{
       var dbClient = await db;
       int res = await dbClient.insert("$itable",item.toMap());
       return res;


  }

   Future<int> saveSale(Sale sale) async{
       var dbClient = await db;
       int res = await dbClient.insert("$stable",sale.toMap());
       return res;


  }
  Future<int> savePurchase(Purchase purchase) async{
       var dbClient = await db;
       int res = await dbClient.insert("$ptable",purchase.toMap());
       return res;


  }


  
Future<List<String>> getAllItemnames() async {

  var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT $columnName FROM $itable ");
  List<String> list = new List();
    for(var x in result){
      x.forEach((k,v)=>list.add(v));
    }
    return list;
  
}

Future<List> getAllItems() async {

  var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT * FROM $itable ORDER BY $columnId DESC");
  return result.toList();
}

Future<List> getAllSales() async {

  var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT b.*, a.itemname FROM $stable AS b INNER JOIN $itable as a ON (b._itemid=a._itemid) ORDER BY $columnSid DESC ");
  return result.toList();
}

Future<List> getAllPurchases() async {

  var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT b.*, a.itemname FROM $ptable AS b INNER JOIN $itable as a ON (b._itemid=a._itemid) ORDER BY $columnPid DESC");
  return result.toList();
}




Future<int> getCount() async{
var dbClient = await db;
return Sqflite.firstIntValue(
  await dbClient.rawQuery("SELECT COUNT(*) FROM $itable")
);
}
Future<int> getsCount() async{
var dbClient = await db;
return Sqflite.firstIntValue(
  await dbClient.rawQuery("SELECT COUNT(*) FROM $stable")
);
}
Future<int> getpCount() async{
var dbClient = await db;
return Sqflite.firstIntValue(
  await dbClient.rawQuery("SELECT COUNT(*) FROM $ptable")
);
}


 

 Future<dynamic> getItem(int id) async{
   var dbClient = await db;
   var result = await dbClient.rawQuery("SELECT * FROM $itable WHERE $columnId = $id");
   if(result.length == 0) return null;
   return result.first;
 }
 Future<dynamic> getSale(int id) async{
   var dbClient = await db;
   var result = await dbClient.rawQuery("SELECT * FROM $stable WHERE $columnSid = $id");
   if(result.length == 0) return null;
   return result.first;
 }
 Future<dynamic> getPurchase(int id) async{
   var dbClient = await db;
   var result = await dbClient.rawQuery("SELECT * FROM $ptable WHERE $columnPid = $id");
   if(result.length == 0) return null;
   return result.first;
 }

Future<List> getItemsearch(String query) async{
   var dbClient = await db;
   var result = await dbClient.rawQuery("SELECT * FROM $itable WHERE $columnName like '%$query%'");
   if(result.length == 0) return null;
   return result.toList();
}
Future<List> getSalesearch(String query) async{
   var dbClient = await db;
   var result = await dbClient.rawQuery("SELECT b.*, a.itemname FROM $stable AS b INNER JOIN $itable as a ON (a.itemname LIKE '%$query%' AND b._itemid=a._itemid)");
   if(result.length == 0) return null;
   return result.toList();
}
Future<List> getPurchasesearch(String query) async{
   var dbClient = await db;
   var result = await dbClient.rawQuery("SELECT b.*, a.itemname FROM $ptable AS b INNER JOIN $itable as a ON (b._itemid=a._itemid) ORDER BY $columnPid DESC");
   if(result.length == 0) return null;
   return result.toList();
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