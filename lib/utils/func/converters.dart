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

  static String formatNumberEn(double num) {
    NumberFormat myFormat =
        NumberFormat.decimalPattern('en'); // Using 'en' for comma separation
    return myFormat.format(num);
  }

  static formatNumberDigits(double num) {
    NumberFormat myFormat = NumberFormat("#.####");
    return myFormat.format(num);
  }

  static String formatNumberWithDigits(double num, {int decimalPlaces = 4}) {
    // Create a custom pattern that combines locale formatting and decimal precision
    String pattern =
        "#,##0.${"#" * decimalPlaces}"; // This will format the number with up to `decimalPlaces` decimal points
    NumberFormat myFormat =
        NumberFormat(pattern, 'ar'); // 'ar' is for Arabic locale

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
