import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class BdManager {
  static const String _dbName = 'MyData.db';
  static const String _tableProducts = 'Products';

  static Database? _database;

  static Future<Database> get database async {
   
    Database db = _database ??
        await openDatabase(
            join(await getDatabasesPath(), BdManager._dbName),
            version: 1, onCreate: (Database db, int version) async {
      
          await db.execute(
              'CREATE TABLE $_tableProducts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, stock INTEGER, price REAL)');
        });

    _database ??= db; 
    return db;
  }

  static Future<void> close(  ) async {
    (await database).close();
    _database = null;
  }

  static Future<void> deleteDb() async {
    deleteDatabase(join(await getDatabasesPath(), BdManager._dbName));
    _database = null;
  }

  static Future<int> insert(String name, int stock, double price) async {

    Database db = await database;

    return await db.rawInsert(

        'INSERT INTO $_tableProducts(name, stock, price) VALUES(?, ?, ?)',
        [name, stock, price]);
  }

  static Future<List<Map<String, Object?>>> getAll() async {
    Database db = await database;

    await Future.delayed(const Duration(milliseconds: 300));
    return db.rawQuery('SELECT * FROM $_tableProducts');
  }

  static Future<int> deleteAll(int num) async {
    Database db = await database;
    return db.delete(_tableProducts, where: 'id >= ?', whereArgs: [num]);
  }

  static Future<int> deleteId(int num) async {
    Database db = await database;
    return db.delete(_tableProducts, where: 'id == ?', whereArgs: [num]);
  }
  static Future<List<Map<String, Object?>>> getProduct(int id) async {
    Database db = await database;
    return db.query(_tableProducts, where: 'id = ?', whereArgs: [id]);
  }
}
