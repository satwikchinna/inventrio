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
   static final columnbarCode = 'itembarcode';
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
String path = join(documentDirectory.path,"maindb2.db");

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
            $columnCp REAL NOT NULL,
            $columnbarCode TEXT
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

   void saveSale(String name,String doc,double quantity,double price) async{
       var dbClient = await db;
       dbClient.rawQuery("INSERT INTO $stable(quantity,sellingprice,doc,_itemid) VALUES($quantity,$price,'$doc',(SELECT _itemid FROM $itable WHERE $columnName = '$name')) ");
       dbClient.rawQuery("UPDATE $itable SET $columnStock =CASE WHEN  ($columnStock - $quantity) < 0 THEN 0 ELSE ($columnStock - $quantity) END ,$columnSp = $price WHERE $columnName = '$name' ");
       


  }
 
   void savePurchase(String name,String doc,double quantity,double price) async{
       var dbClient = await db;
       dbClient.rawQuery("INSERT INTO $ptable(quantity,costprice,doc,_itemid) VALUES($quantity,$price,'$doc',(SELECT _itemid FROM $itable WHERE $columnName = '$name')) ");
       dbClient.rawQuery("UPDATE $itable SET $columnStock = $columnStock + $quantity , $columnCp = $price WHERE $columnName = '$name' ");
       


  }
  Future<List> getAnalysis() async{

     var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT SUBSTR($columnDate,0,11) as day,SUM($columnSp*$columnQuantity) as income FROM $stable GROUP BY SUBSTR($columnDate,0,11) ");
  
    return result;
  }

    Future<Map> gethiglySelling() async{

     var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT $columnName as hitem FROM $stable WHERE $columnQuantity = MAX($columnQuantity) ");
   
    
    return result.first;
  }

 Future<List<double>> gettotalmIncomes() async{

     var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT SUM($columnSp*$columnQuantity) as income FROM $stable GROUP BY SUBSTR($columnDate,0,8) ");
  List<double> list = new List();
    for(var x in result){
      x.forEach((k,v)=>list.add(v));
    }
    return list;
   
  }

  Future<List<double>> gettotalmPurchases() async{

     var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT SUM($columnCp*$columnQuantity) as investment FROM $ptable GROUP BY SUBSTR($columnDate,0,8) ");
  List<double> list = new List();
    for(var x in result){
      x.forEach((k,v)=>list.add(v));
    }
    return list;
   
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

Future getCodeItems(String code) async {

  var dbClient = await db;
  var result = await dbClient.rawQuery("SELECT * FROM $itable WHERE $columnbarCode = '$code'");
  if(result.length == 0) return null;
   return result.first;
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