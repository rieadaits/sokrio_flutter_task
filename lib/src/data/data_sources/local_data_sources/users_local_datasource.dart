import 'package:sokrio_flutter_task/src/data/models/users_response.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../core/error/falures.dart';

abstract class UsersLocalDataSource {
  Future<List<User>> getLastUsers();
  Future<void> cacheUsers(List<User> localUsers);
}

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sokrio_user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE local_users(
            id INTEGER PRIMARY KEY,
            first_name TEXT,
            last_name TEXT,
            email TEXT,
            avatar TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<List<User>> getLastUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('local_users');

      return List.generate(maps.length, (i) {
        return User.fromJson(maps[i]);
      });
    } catch (e) {
      throw CacheFailure('Failed to get cached users');
    }
  }

  @override
  Future<void> cacheUsers(List<User> localUsers) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('local_users');
        for (var repository in localUsers) {
          await txn.insert(
            'local_users',
            repository.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      throw CacheFailure('Failed to cache users');
    }
  }
}
