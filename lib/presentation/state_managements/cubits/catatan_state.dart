part of 'catatan_cubit.dart';



class CatatanState extends Equatable{
  List<Catatan>? catatanList;
  CatatanState({this.catatanList});
  @override
  List<Object?> get props => [catatanList];
}
