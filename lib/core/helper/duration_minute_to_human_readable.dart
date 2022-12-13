import 'package:persiapan_test_deptech/presentation/widgets/my_toast.dart';

String durationMinuteToHumanReadable(int durationInMinute, {Function(String)? callback}){

  var hariString = "";
  var jamString = "";
  var hari = durationInMinute ~/ 60 ~/ 24;
  var jam = durationInMinute ~/ 60 % 24;
  if(hari > 0) hariString = "$hari hari ";
  if(jam > 0) jamString = "$jam jam ";
  // if(menit > 0) menitString = "$menit menit";
  if(callback != null){
    callback(hariString + jamString);
  }
  return hariString + jamString;
}

void popUpReminder(int durationInMinute){
  var value = durationMinuteToHumanReadable(durationInMinute);
  myToast("Reminder in $value");
}