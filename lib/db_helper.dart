import 'package:sqflite/sqflite.dart' as sql;
import "package:path/path.dart" as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'events.db'), version: 1,
        onCreate: ((db, version) {
      return db.execute('''CREATE TABLE calendar_events(
            id TEXT PRIMARY KEY, 
            title TEXT, 
            description TEXT, 
            from TEXT, 
            to TEXT
            )''');
    }));
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqldb = await database();
    sqldb.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object?>>> getData(String table) async {
    final sqldb = await database();
    return sqldb.query(table);
  }
}
