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
}
