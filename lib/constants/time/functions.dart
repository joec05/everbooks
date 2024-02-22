String convertDateTimeDisplay(String dateTime){
  if(DateTime.tryParse(dateTime) == null){
    if(dateTime.length == 4){
      return dateTime;
    }else{
      return '?';
    }
  }
  List<String> separatedDateTime = DateTime.parse(dateTime).toLocal().toIso8601String().substring(0, 10).split('-').reversed.toList();
  List<String> months = [
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  separatedDateTime[1] = months[int.parse(separatedDateTime[1])];
  return separatedDateTime.join(' ');
}