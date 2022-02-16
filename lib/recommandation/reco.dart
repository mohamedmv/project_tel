import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models.dart';

Future<String> get localPath async {
  final dir = await getApplicationDocumentsDirectory();

  return dir.path;
}

Future<File> _localFile(String nomsim) async {
  final path = await localPath;

  return File('$path/$nomsim.txt');
}

Future<String > dbPath() async {
  var databasesPath = await getDatabasesPath();
  String dbName = "recomandation.db";
return "$databasesPath$dbName";
}

Future<Database> getDB() async{
 String path = await dbPath();
 return await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
  // When creating the db, create the table
  await db.execute(
      'CREATE TABLE Servicemattel (id INTEGER PRIMARY KEY AUTOINCREMENT, sId TEXT, count INTEGER)');
      await db.execute(
      'CREATE TABLE Servicemauritel(id INTEGER PRIMARY KEY AUTOINCREMENT, sId TEXT, count INTEGER)');
      await db.execute(
      'CREATE TABLE Servicemauritani (id INTEGER PRIMARY KEY AUTOINCREMENT, sId TEXT, count INTEGER)');
});
}

Future<File> write(String counter, String nomsim) async {
  final file = await _localFile(nomsim);

  // Write the file

  return file.writeAsString('$counter');
}

Future<String?> read(String nomsim) async {
  try {
    final file = await _localFile(nomsim);

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return null;
  }
}

String asString(List<Service> l) {
  String s = '';
  for (Service serv in l) s += "${serv.id};${serv.count};;";

  return s;
}

Future<void> incremant(Service s, String nomsim) async {
  Database db = await getDB();
  List<Map> data = await db.rawQuery("select * from service$nomsim where sId = '${s.id}' ");
  if(data.isEmpty) {
    await db.transaction((txn) async {
  int id1 = await txn.rawInsert(
      "INSERT INTO service$nomsim ( sId , count ) VALUES('${s.id}', 1)");
  print('inserted1: $id1');
 ;
});
  }
  else{
    int count = data[0]['count']+1;
    int id = data[0]['id'];
    int result = await db.rawUpdate(
    'UPDATE service$nomsim  SET count = ? WHERE id = ?',
    [count,id]);

  }
}

Future<List<String>> sortedListService(String nomsim) async {
  Database db = await getDB();
   List<String> services = [];
   List<Map> data = await db.rawQuery(" select  * from service$nomsim ORDER BY count DESC limit 4");
   
   for(Map element in data){
     print("++++++++++++++");
     print("::${element['sId']}");

     services.add( element['sId']  );
   }
  
  


  return  services;
}
