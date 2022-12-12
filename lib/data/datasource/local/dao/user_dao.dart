import 'package:sqflite/sqflite.dart';
import '../../../model/user.dart';
import '../database/app_db.dart';

class UserDao {
    Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await DB.instance.database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

    Future<void> updateUser(User user) async {
      // Get a reference to the database.
      final db = await DB.instance.database;

      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      await db.update(
        'users',
        user.toMap(),
        where:'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [user.id],
      );
    }

    Future<User> getLoggedInUser(int id) async {
      final db = await DB.instance.database;
      var queryResults = await db.query('users',where: "id = ?",whereArgs: [id]);
      var returnedUser = queryResults.first;
      return User.fromMap(
        returnedUser
      );
    }

    Future<User?> login(String email, String password) async {
      final db = await DB.instance.database;
      var queryResults = await db.rawQuery("SELECT * FROM users WHERE email=? and password=?",[email,password]);
      var returnedUser = queryResults.isNotEmpty ? queryResults.first : <String,dynamic>{};
      return  returnedUser.isNotEmpty ? User.fromMap(
          returnedUser
      ) : null;
    }
}