import 'dart:async';
import 'dart:core';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/user.dart';
class DB  {

  static final DB _db = new DB._internal();
  DB._internal();
  static DB get instance => _db;
  static Database? _database;

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _init();
    return _database!;

  }

  Future<Database> _init() async{
    return await openDatabase(

      join(await getDatabasesPath(), 'database_name.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, nama_depan TEXT, nama_belakang TEXT, email TEXT, tanggal_lahir INTEGER, jenis_kelamin TEXT, password TEXT, foto_profil TEXT)',
        );
        await db.execute(
          'CREATE TABLE catatan(id INTEGER PRIMARY KEY, judul TEXT, deskripsi TEXT, waktu_pengingat INTEGER, interval_pengingat INTEGER, lampiran TEXT)',
        );
        await db.insert("users",
            User(
              namaDepan: "Aldi",
              namaBelakang: "Majid",
              email: "aldiirsanmajid@gmail.com",
              tanggalLahir: DateTime(1998,10,2),
              jenisKelamin: "L",
              password: "abcde123",
            ).toMap());
      },
      version: 1,
    );
  }

}
