import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const String error400 =
    "Error in parsing data, please check the value inserted";
const String error401 = "This transaction is not authorized";
const String error405 =
    "This transaction cannot be completed due to incorrect request";
const String error500 =
    "The proccess could not be completed due to server error";
const String error406 = "Something went wrong";
const String error204 = "No User Found";
const String error404 = "Not Found";

void showLoading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
            child: Lottie.asset("assets/images/inventory_loading.json",
                width: 250, height: 250));
      });
}
