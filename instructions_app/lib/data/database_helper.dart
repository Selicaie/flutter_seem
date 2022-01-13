// import 'dart:async';
// import 'dart:io' as io;
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import 'package:instructions_app/models/users.dart';


// class DatabaseHelper {
//   String tblUser = "User";
//   String colId = "id";
//   String colUserId = "userId";
//   String colUserName = "username";
//   String colPassword = "password";  
//   String colDate = "date";
//   static final DatabaseHelper _instance = new DatabaseHelper.internal();
//   factory DatabaseHelper() => _instance;

//   static Database _db;

//   Future<Database> get db async {
//     if(_db != null)
//       return _db;
//     _db = await initDb();
//     return _db;
//   }

//   DatabaseHelper.internal();

//   initDb() async {
//     io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "main.db");
//     var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return theDb;
//   }
  

//   void _onCreate(Database db, int version) async {
//     // When creating the db, create the table
//     await db.execute(
//     "CREATE TABLE $tblUser($colUserId INTEGER PRIMARY KEY, username TEXT, $colPassword TEXT, $colDate TEXT, $colId INTEGER)");
//     print("Created tables");
//   }

//   Future<int> saveUser(User user) async {
//     var dbClient = await this.db;
//     int res = await dbClient.insert(tblUser, user.toMap());
//     return res;
//   }
// Future<User> getUser(int id) async {
//     var dbClient = await this.db;
//     List<Map> res = await dbClient.rawQuery("SELECT * FROM $tblUser where $colId = $id");
//     if (res.length > 0) {
//       return User.fromMap(res.first);
//     }
//     return null ;
//   }
//   Future<int> deleteUsers() async {
//     var dbClient = await this.db;
//     int res = await dbClient.delete(tblUser);
//     return res;
//   }
// Future<int> deleteUser(int id) async {
//     int result;
//     var dbClient = await this.db;
//     result = await dbClient.rawDelete('DELETE FROM $tblUser WHERE $colId = $id');
//     return result;
//   }
//   Future<bool> isLoggedIn() async {
//     var dbClient = await this.db;
//     var res = await dbClient.query(tblUser);
//     return res.length > 0? true: false;
//   }

// }