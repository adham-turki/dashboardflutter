import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/reports/select_model.dart';

class ReportsProvider with ChangeNotifier {
  String totalCollectionPeriod = "";
  String totalCollectionStatus = "";
  String totalCollectionChart = "";
  String dailySalesPeriod = "";
  String dailySalesCollectionStatus = "";
  String dailySalesCollectionChart = "";
  int totalCollectionChartIndex = -1;
  int totalCollectionStatusIndex = -1;
  int totalCollectionPeriodIndex = -1;
  int dailySalesChartIndex = -1;
  int dailySalesStatusIndex = -1;
  int totalSalesPeriodIndex = -1;
  int totalSalesStatusIndex = -1;
  int branchSalesChartIndex = -1;
  int branchSalesPeriodIndex = -1;
  int branchSalesCatIndex = -1;
  String? fromDate;
  String? toDate;

  Map<String, dynamic> branchesMap = {};

  void setBranchesMap(AppLocalizations local, Map<String, dynamic> branches) {
    branchesMap.addAll({});
    // branchesMap[local.all] = "";
    branchesMap.addAll(branches);
  }

  Map<String, dynamic> getBranch() => branchesMap;

  void setTotalSalesStatusIndex(int status) {
    totalSalesStatusIndex = status;
    notifyListeners();
  }

  int getTotalSalesStatusIndex() {
    return totalSalesStatusIndex;
  }

  void clearProvider() {
    totalCollectionPeriod = "";
    totalCollectionStatus = "";
    totalCollectionChart = "";
    dailySalesPeriod = "";
    dailySalesCollectionStatus = "";
    dailySalesCollectionChart = "";
    totalCollectionChartIndex = -1;
    totalCollectionStatusIndex = -1;
    totalCollectionPeriodIndex = -1;
    dailySalesChartIndex = -1;
    dailySalesStatusIndex = -1;
    totalSalesPeriodIndex = -1;
    totalSalesStatusIndex = -1;
    branchSalesChartIndex = -1;
    branchSalesPeriodIndex = -1;
    branchSalesCatIndex = -1;

    notifyListeners();
  }

  void setTotalCollectionPeriod(String period) {
    totalCollectionPeriod = period;
    notifyListeners();
  }

  String getTotalCollectionPeriod() {
    return totalCollectionPeriod;
  }

  void setDailySalesPeriod(String period) {
    dailySalesPeriod = period;
    notifyListeners();
  }

  String getDailySalesPeriod() {
    return dailySalesPeriod;
  }

  void setTotalCollectionStatus(String status) {
    totalCollectionStatus = status;
    notifyListeners();
  }

  String getTotalCollectionStatus() {
    return totalCollectionStatus;
  }

  void setTotalCollectionChart(String chart) {
    totalCollectionChart = chart;
    notifyListeners();
  }

  String getTotalCollectionChart() {
    return totalCollectionChart;
  }

  void setTotalCollectionChartIndex(int chart) {
    totalCollectionChartIndex = chart;
    notifyListeners();
  }

  int getTotalCollectionChartIndex() {
    return totalCollectionChartIndex;
  }

  void setTotalCollectionStatusIndex(int status) {
    totalCollectionStatusIndex = status;
    notifyListeners();
  }

  int getTotalCollectionStatusIndex() {
    return totalCollectionStatusIndex;
  }

  void setTotalCollectionPeriodIndex(int period) {
    totalCollectionPeriodIndex = period;
    notifyListeners();
  }

  int getTotalCollectionPeriodIndex() {
    return totalCollectionPeriodIndex;
  }

  void setDailySalesChartIndex(int chart) {
    dailySalesChartIndex = chart;
    notifyListeners();
  }

  int getDailySalesChartIndex() {
    return dailySalesChartIndex;
  }

  void setDailySalesStatusIndex(int chart) {
    dailySalesStatusIndex = chart;
    notifyListeners();
  }

  int getDailySalesStatusIndex() {
    return dailySalesStatusIndex;
  }

  void setTotalSalesPeriodIndex(int chart) {
    totalSalesPeriodIndex = chart;
    notifyListeners();
  }

  int getTotalSalesPeriodIndex() {
    return totalSalesPeriodIndex;
  }

  void setBranchSalesChartIndex(int chart) {
    branchSalesChartIndex = chart;
    notifyListeners();
  }

  int getBranchSalesChartIndex() {
    return branchSalesChartIndex;
  }

  void setBranchSalesPeriodIndex(int chart) {
    branchSalesChartIndex = chart;
    notifyListeners();
  }

  int getBranchSalesPeriodIndex() {
    return branchSalesChartIndex;
  }

  void setBranchSalesCatIndex(int chart) {
    branchSalesCatIndex = chart;
    notifyListeners();
  }

  int getBranchSalesCatIndex() {
    return branchSalesCatIndex;
  }

  SelectModel? _stockType;
  void setStockType(SelectModel? status) {
    _stockType = status;
    notifyListeners();
  }

  SelectModel? get getStockType => _stockType;

  SelectModel? _usePrice;
  void setUsePrice(SelectModel? status) {
    _usePrice = status;
    notifyListeners();
  }

  SelectModel? get getUsePrice => _usePrice;

  SelectModel? _status;
  void setStatus(SelectModel? status) {
    _status = status;
    notifyListeners();
  }

  SelectModel? get getSatus => _status;

  SelectModel? _orderBy;
  void setOrderBy(SelectModel? orderBy) {
    _orderBy = orderBy;
    notifyListeners();
  }

  SelectModel? get getOrderBy => _orderBy;

  SelectModel? _orderByCat;
  void setOrderByCat(SelectModel? orderBy) {
    _orderByCat = orderBy;
    notifyListeners();
  }

  SelectModel? get getOrderByCat => _orderByCat;

  String? get getFromDate => fromDate;
  void setFromDate(String? value) {
    fromDate = value;
    notifyListeners();
  }

  String? get getToDate => toDate;
  void setToDate(String? value) {
    toDate = value;
    notifyListeners();
  }
}
