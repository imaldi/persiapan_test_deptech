import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:persiapan_test_deptech/data/datasource/local/dao/catatan_dao.dart';

import '../../../data/model/catatan.dart';

part 'catatan_state.dart';

class CatatanCubit extends Cubit<CatatanState> {
  CatatanCubit() : super(CatatanState());

  initList() async {
    var catatanDao = CatatanDao();
    var list = await catatanDao.catatanList();
    emit(CatatanState(catatanList: list));
  }
}
