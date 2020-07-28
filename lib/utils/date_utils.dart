

class DateUtils {



  static String convertIntToString(int dateInt){
    var dateTime = DateTime.fromMillisecondsSinceEpoch(dateInt);
    return dateTime.toString();
  }

}

