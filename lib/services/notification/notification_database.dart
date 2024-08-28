import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'notification_model.dart';

class NotificationDatabase {
  static final NotificationDatabase instance = NotificationDatabase._init();

  static Database? _database;

  NotificationDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const nullableTextType = 'TEXT';
    const dateTimeType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE notifications (
      id $idType,
      title $textType,
      message $textType,
      appIcon $nullableTextType,
      largeIcon $nullableTextType,
      dateTime $dateTimeType
    )
    ''');
  }

  Future<void> insertNotification(NotificationModel notification) async {
    final db = await instance.database;

    await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NotificationModel>> fetchAllNotifications() async {
    final db = await instance.database;

    final maps = await db.query('notifications');

    return List.generate(maps.length, (i) {
      return NotificationModel.fromMap(maps[i]);
    });
  }
}
