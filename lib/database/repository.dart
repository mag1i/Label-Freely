import 'package:sqflite/sqflite.dart';

import 'cnx.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection= DatabaseConnection();
  }
  static Database? _database;
  Future<Database?>get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }
  readDataBylabel(table, labelId) async {
    var connection = await database;
    return await connection?.query(table, where: 'idlbl=?', whereArgs: [labelId]);
  }
  readDataByCategory(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'idlbl=?', whereArgs: [itemId]);
  }
  readDataBycheck(table) async {
    var connection = await database;
    return await connection?.rawQuery("select id from Todos where checked=1");
  }

  readDataBycheckcat(table, idlbl) async {
    var connection = await database;
    return await connection?.rawQuery("select id from Todos where checked=1 and idlbl=$idlbl");
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  updatNote( id, val) async {
    var connection = await database;
    return await connection?.rawUpdate("UPDATE notes SET content= '$val' WHERE id=$id");
  }
  updatNotetitle( id, val) async {
    var connection = await database;
    return await connection?.rawUpdate("UPDATE notes SET title= '$val' WHERE id=$id");
  }
  updatetodo( id, check) async {
    var connection = await database;
    return await connection?.rawUpdate("UPDATE Todos SET checked= $check WHERE id=$id");

  }
  updateCat(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'idlabel=?', whereArgs: [data['idlabel']]);
  }
  deleteDataById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$itemId");
  }
  deleteevent(table, itemnane) async {
    var connection = await database;
    return await connection?.rawDelete("delete from Events where nameevent=$itemnane");
  }
  deleteEventById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where idevent=$itemId");
  }
  deletectgrById(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where idlabel=$itemId");
  }
  /*Future<Categor>getColor(itemId) async {
    Categor ch= new Categor();
    var connection = await database;
   var  res= await connection?.rawQuery("select colorlabel from Label where idlabel=$itemId");
  // return res!.map((e) => e);
   return ch.lblMap(res[0]);

  }*/



/*
  Future<Photo> save(Photo employee) async {
    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    return employee;
  }

  Future<List<Photo>> getPhotos() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<Photo> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Photo.fromMap(maps[i]));
      }
    }
    return employees;
  }*/
  Future<int> readclrById( itemId) async {
    var connection = await database;
    final mp=  await connection?.rawQuery("select colorlabel from Label where idlabel=$itemId");
    int h= mp!.first.values.first as int;
  //  var hh= mp!.first.values.toList() as int;
   // int hhh= hh[0];
    print(h.toString()+"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    return  h;}
  clr( itemId) async {
    var connection = await database;
    return await connection?.rawQuery("select colorlabel from Label where idlabel=$itemId");
   }


}