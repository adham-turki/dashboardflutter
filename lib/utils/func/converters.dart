import 'package:intl/intl.dart';

class Converters {
  formateDouble(double a) {
    final double formattedValue = a;
    final NumberFormat formatter =
        NumberFormat('0.00'); // Format with two digits after point
    return double.parse(formatter.format(formattedValue));
  }

  static formatNumber(double num) {
    NumberFormat myFormat = NumberFormat.decimalPattern('ar');
    return myFormat.format(num);
  }

  static formatNumberWithCommasAndRounding(double num) {
    // Round the number to 1 decimal place
    double roundedNum = double.parse(num.toStringAsFixed(1));

    // Format the rounded number with commas in Arabic locale
    NumberFormat myFormat = NumberFormat.decimalPattern('ar');
    return myFormat.format(roundedNum);
  }

  static formatNumberRounded(double num) {
    // Round the number to 1 decimal place
    double roundedNum = double.parse(num.toStringAsFixed(1));

    // Format the number in Arabic locale
    NumberFormat myFormat = NumberFormat.decimalPattern('ar');
    return myFormat.format(roundedNum);
  }

  static formatNumberDigits(double num) {
    NumberFormat myFormat = NumberFormat("#.####");
    return myFormat.format(num);
  }

  static String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return dateString; // Return original string if parsing fails
    }
  }

  static String formatDate2(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return dateString; // Return original string if parsing fails
    }
  }
}
