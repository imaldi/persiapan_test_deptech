import 'package:persiapan_test_deptech/data/model/catatan.dart';

import '../database/app_db.dart';
import 'package:sqflite/sqflite.dart';

class CatatanDao {
  Future<void> insertCatatan(Catatan catatan) async {
    // Get a reference to the database.
    final db = await DB.instance.database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'catatan',
      catatan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCatatan(Catatan catatan) async {
    // Get a reference to the database.
    final db = await DB.instance.database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.update(
      'catatan',
      catatan.toMap(),
      where:'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [catatan.id],
    );
  }

  Future<void> deleteCatatan(int id) async {
    // Get a reference to the database.
    final db = await DB.instance.database;

    // Remove the Dog from the database.
    await db.delete(
      'catatan',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<Catatan>> catatanList() async {
    // Get a reference to the database.
    final db = await DB.instance.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('catatan');
    print("List Catatan from dao: $maps");
    final List<Catatan>  list = maps.map((e) => Catatan(
        id: e['id'],
        title: e['title'],
        description: e['description'],
        waktuPengingat: e['waktu_pengingat'] != null ? DateTime.fromMillisecondsSinceEpoch(e['waktu_pengingat']) : null,
        intervalPengingat: e['interval_pengingat'],
        lampiran: e['lampiran'],
      )).toList();




    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return list;
      // [
      //   Catatan(title:"Title 1"),
      //   Catatan(title:"Title 2"),
      //   Catatan(title:"Title 3"),
      // ];

    //   List.generate(maps.length, (i) {
    //   return Catatan(
    //     id: maps[i]['id'],
    //     title: maps[i]['title'],
    //     description: maps[i]['description'],
    //     waktuPengingat: DateTime.fromMillisecondsSinceEpoch(maps[i]['waktu_pengingat']),
    //     intervalPengingat: maps[i]['interval_pengingat'],
    //     lampiran: maps[i]['lampiran'],
    //   );
    // });
  }
}