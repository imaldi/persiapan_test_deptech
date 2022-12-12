String durationMinuteToHumanReadable(int duration){
  var hariString = "";
  var jamString = "";
  var menitString = "";
  var hari = duration ~/ 60 ~/ 24;
  var jam = duration % 60;
  var menit = duration % 60;
  if(hari > 0) hariString = "$hari hari ";
  if(jam > 0) jamString = "$jam jam ";
  if(menit > 0) menitString = "$menit menit";
  return hariString + jamString + menitString;
}