class DateConvert {
  static String getFormattedDate(String date) {
    try {
      String str = "";
      List<String> list = date.split("/");
      String day = list[0];
      String month = list[1];
      String year = list[2];

      str = "$year-$month-$day";

      return str;
    } catch (e) {
      throw const FormatException("Please check date format");
    }
  }
}
