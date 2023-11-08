import 'package:flutter/material.dart';

///colors
const darkBlueColor = Color(0xFF2b4381);
const blueColor = Color(0xff17a2b8);
var greenColor = const Color(0xff57b846);
const blackColor = Color.fromARGB(255, 0, 0, 0);
int selected = 1;
int selectedOriginal = 1;
int selectedSub = 0;

ButtonStyle customButtonStyle(Size size, double fontSize, Color color) {
  return ElevatedButton.styleFrom(
      backgroundColor: color,
      fixedSize: size,
      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      alignment: Alignment.center);
}

const appPadding = 16.0;
const textColor = Colors.black;

LinearGradient createGradient(Color endColor) {
  return LinearGradient(
    colors: [Colors.white, endColor],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}

///routes
const loginScreenRoute = "/login";
const monthlyComparisonScreenRoute = "/monthlyComparisonScreenRoute";
const agingReceivableScreenRoute = "/agingReceivableScreenRoute";
const expensesScreenRoute = "/expensesScreenRoute";
const outStandingChequesScreenRoute = "/outStandingChequesScreenRoute";
const chequesAndBanksScreenRoute = "/chequesAndBanksScreenRoute";
const inventoryPerformanceScreenRoute = "/inventoryPerformanceScreenRoute";
const cashFlowsScreenRoute = "/cashFlowsScreenRoute";
const purchasesReportScreenRoute = "/purchasesReportScreenRoute";
const salesReportScreenRoute = "/salesReportScreenRoute";
const totalSalesScreenRoute = "/totalSalesScreenRoute";
const setupScreenRoute = "/setupScreenRoute";
const changePasswordScreenRoute = "/changePasswordScreenRoute";
const totalCollectionsScreenRoute = "/totalCollectionsScreenRoute";
const salesByBranchesScreenRoute = "/salesByBranchesScreenRoute";
const dailySalesScreenRoute = "/dailySalesScreenRoute";
const branchSalesByCategoriesScreenRoute =
    "/branchSalesByCategoriesScreenRoute";
const purchseReportScreenRoute = "/purchasesReportScreenRoute";
const mainScreenRoute = "/mainScreenRoute";
const dashboard = "/dashboard";
