import 'package:intl/intl.dart';

class Converters {
  formateDouble(double a) {
    final double formattedValue = a;
    final NumberFormat formatter =
        NumberFormat('0.00'); // Format with two digits after point
    return double.parse(formatter.format(formattedValue));
  }

  static String formatTitleNumber(double total) {
    if (total >= 1000 && total < 1000000) {
      return "${(total / 1000).toStringAsFixed(1)}k"; // For numbers in the thousands (e.g., 1.5k for 1500)
    } else if (total >= 1000000 && total < 1000000000) {
      return "${(total / 1000000).toStringAsFixed(1)}M"; // For numbers in the millions (e.g., 2.5M for 2500000)
    } else if (total >= 1000000000) {
      return "${(total / 1000000000).toStringAsFixed(1)}B"; // For numbers in the billions (e.g., 3.0B for 3000000000)
    }

    return total
        .toStringAsFixed(2); // For numbers smaller than 1000, return as-is
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
    // double roundedNum = double.parse(num.toStringAsFixed(1));

    // NumberFormat myFormat = NumberFormat.decimalPattern('ar');
    // return myFormat.format(roundedNum);
    // Convert the number to an integer (remove the decimal part)
    int integerNum = num.toInt();

    // Format the integer number in Arabic locale
    NumberFormat myFormat = NumberFormat.decimalPattern('ar');
    return myFormat.format(integerNum);
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
