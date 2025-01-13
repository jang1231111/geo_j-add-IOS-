import 'package:geo_j/data/db/db_helper.dart';
import 'package:geo_j/models/user.dart';

class UserRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addUser(User user) async {
    final db = await dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final db = await dbHelper.database;
    final result = await db.query('users');
    return result.map((e) => User.fromMap(e)).toList();
  }

  Future<int> deleteUser(int id) async {
    final db = await dbHelper.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
