import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection{
  Future<Database>setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'FrLbl.db');
    var database =
    await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void>_createDatabase(Database database, int version) async {
    String sql=
        "CREATE TABLE cont(id TEXT PRIMARY KEY, name TEXT,number TEXT, note TEXT, image TEXT , email TEXT, idlbl INTEGER, FOREIGN KEY (idlbl) REFERENCES Label (idlabel)ON DELETE NO ACTION ON UPDATE NO ACTION );";
    await database.execute(sql);
    String sql2=
    "CREATE TABLE Label(idlabel INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, namelabel TEXT,colorlabel INTEGER );";
    await database.execute(sql2);
    String sql1= "INSERT INTO Label(namelabel, colorlabel) VALUES('General', 36013);";
    await database.execute(sql1);
    String sql3=
        "CREATE TABLE Events(idevent INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nameevent TEXT, startdate TEXT, enddate TEXT,starthour INTEGER,startmin INTEGER, endhour INTEGER,endtmin INTEGER, colorevent INTEGER  );";
    await database.execute(sql3);
    String sql4=
        "CREATE TABLE Todos(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, date TEXT,  checked INTEGER, idlbl INTEGER, FOREIGN KEY (idlbl) REFERENCES Labelnotes (idlabel)ON DELETE NO ACTION ON UPDATE NO ACTION );";
    await database.execute(sql4);
    String sql5=
        "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, content TEXT, title TEXT, date TEXT , idlbl INTEGER, image TEXT,  FOREIGN KEY (idlbl) REFERENCES Labelnotes (idlabel)ON DELETE NO ACTION ON UPDATE NO ACTION  );";
    await database.execute(sql5);
    String sql6=
        "CREATE TABLE Labelnotes(idlabel INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, namelabel TEXT,colorlabel INTEGER );";
    await database.execute(sql6);
    String sql7= "INSERT INTO Labelnotes (namelabel, colorlabel) VALUES('General', 36013);";
    await database.execute(sql7);
    String sql8= "CREATE TABLE Reminders(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  );";
    await database.execute(sql8);

    //ON DELETE NO ACTION ON UPDATE NO ACTION
  }
}