import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? namaDepan;
  final String? namaBelakang;
  final String? email;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? password;

  /// this field's value is only the path
  final String? fotoProfil;

  const User({
    this.id,
    this.namaDepan,
    this.namaBelakang,
    this.email,
    this.tanggalLahir,
    this.jenisKelamin,
    this.password,
    this.fotoProfil,
  });

  User copyWith({
    int? id,
    String? namaDepan,
    String? namaBelakang,
    String? email,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? password,
    String? fotoProfil,
  }) {
    return User(
      id: id ?? this.id,
      namaDepan: namaDepan ?? this.namaDepan,
      namaBelakang: namaBelakang ?? this.namaBelakang,
      email: email ?? this.email,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      password: password ?? this.password,
      fotoProfil: fotoProfil ?? this.fotoProfil,
    );
  }

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap({bool tanggalLahirAsDate = false}) {
    return {
      "id": id,
      "nama_depan": namaDepan,
      "nama_belakang": namaBelakang,
      "email": email,
      "tanggal_lahir": tanggalLahirAsDate
          ? tanggalLahir.toString()
          : tanggalLahir?.millisecondsSinceEpoch,
      "jenis_kelamin": jenisKelamin,
      "password": password,
      "foto_profil": fotoProfil,
    };
  }

  factory User.fromMap(Map<String, dynamic> theMap) {
    return User(
      id: theMap["id"],
      namaDepan: theMap["nama_depan"],
      namaBelakang: theMap["nama_belakang"],
      email: theMap["email"],
      tanggalLahir:
          DateTime.fromMillisecondsSinceEpoch(theMap["tanggal_lahir"]),
      jenisKelamin: theMap["jenis_kelamin"],
      password: theMap["password"],
      fotoProfil: theMap["foto_profil"],
    );
  }

  @override
  List<Object?> get props => [
        namaDepan,
        namaBelakang,
        email,
        tanggalLahir,
        jenisKelamin,
        password,
        fotoProfil,
      ];

  @override
  toString() {
    return toMap(tanggalLahirAsDate: true).toString();
  }
}
