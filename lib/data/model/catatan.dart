import 'package:equatable/equatable.dart';

class Catatan extends Equatable{
  final int? id;
  final String? title;
  final String? description;
  final DateTime? waktuPengingat;
  final int? intervalPengingat;
  /// this field's value is only the path
  final String? lampiran;

  const Catatan(
      {
      this.id,
      this.title,
      this.description,
      this.waktuPengingat,
      this.intervalPengingat,
      /// this field's value is only the path
      this.lampiran});

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "title" : title,
      "description" : description,
      "waktu_pengingat" : waktuPengingat,
      "interval_pengingat" : intervalPengingat,
      "lampiran" : lampiran,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    waktuPengingat,
    intervalPengingat,
    lampiran,
  ];
}
