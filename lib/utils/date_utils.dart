

class DateUtils {



  static String convertIntToString(int seconds){
    var dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    return dateTime.toString();
  }

}

