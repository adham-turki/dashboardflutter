import 'package:flutter/material.dart';

class SalesCriteraProvider with ChangeNotifier {
  String? fromDate;
  String? toDate;
  int? page;
  bool? checkMultipleBranch;
  bool? checkAllBranch;
  List<String>? codesBranch;
  bool? checkMultipleStockCategory1;
  bool? checkAllStockCategory1;
  List<String>? codesStockCategory1;
  bool? checkMultipleStockCategory2;
  bool? checkAllStockCategory2;
  List<String>? codesStockCategory2;
  bool? checkMultipleStockCategory3;
  bool? checkAllStockCategory3;
  List<String>? codesStockCategory3;
  bool? checkMultipleSupplier;
  bool? checkAllSupplier;
  List<String>? codesSupplier;
  bool? checkMultipleCustomer;
  bool? checkAllCustomer;
  List<String>? codesCustomer;
  bool? checkMultipleCustomerCategory;
  bool? checkAllCustomerCategory;
  List<String>? codesCustomerCategory;
  bool? checkMultipleStock;
  bool? checkAllStock;
  List<String>? codesStock;
  bool? checkMultipleCompaig;
  List<String>? compaigList;
  String? campaignNo;
  String? modelNo;
  List<int>? orders;
  String? viewCodeBarcode;
  String? transType;
  bool? appearBasicUnitEquiv;
  bool? appearInactiveStocks;
  bool? appearInactiveStocksForPurchase;
  bool? appearLocation;
  bool? roundingQty;
  bool? roundingPrice;
  bool? taxIncluded;
  bool? appearDiscount;
  bool? useItemCostPrice;
  bool? usedCostPrice;
  String? used;
  List<String>? stkCat1List,
      stkCat2List,
      stkCat3List,
      stocksList,
      customerList,
      supplierList,
      branchesList,
      custCatList;

  // Map<int, int>? indexMap;
  String? val1 = "", val2 = "", val3 = "", val4 = "";
  String? fromCateg1,
      toCateg1,
      fromCateg2,
      toCateg2,
      fromCateg3,
      toCateg3,
      fromCust,
      toCust,
      fromSupp,
      toSupp,
      fromBranch,
      toBranch,
      fromStock,
      toStock,
      fromCustCateg,
      toCustCateg;

  List<String>? get getStkCat1List => stkCat1List;
  void setStkCat1List(List<String>? value) {
    stkCat1List = value;
    notifyListeners();
  }

  List<String>? get getStkCat2List => stkCat2List;
  void setStkCat2List(List<String>? value) {
    stkCat2List = value;
    notifyListeners();
  }

  List<String>? get getStkCat3List => stkCat3List;
  void setStkCat3List(List<String>? value) {
    stkCat3List = value;
    notifyListeners();
  }

  List<String>? get getStockList => stocksList;
  void setStockList(List<String>? value) {
    stocksList = value;
    notifyListeners();
  }

  List<String>? get getBranchList => branchesList;
  void setBranchList(List<String>? value) {
    branchesList = value;
    notifyListeners();
  }

  List<String>? get getCustomersList => customerList;
  void setCustomersList(List<String>? value) {
    customerList = value;
    notifyListeners();
  }

  List<String>? get getSupplierList => supplierList;
  void setSupplierList(List<String>? value) {
    supplierList = value;
    notifyListeners();
  }

  List<String>? get getCustCateg => custCatList;
  void setCustCateg(List<String>? value) {
    custCatList = value;
    notifyListeners();
  }

  String? get getVal1 => val1;
  void setVal1(String? value) {
    val1 = value;
    notifyListeners();
  }

  String? get getVal2 => val2;
  void setVal2(String? value) {
    val2 = value;
    notifyListeners();
  }

  String? get getVal3 => val3;
  void setVal3(String? value) {
    val3 = value;
    notifyListeners();
  }

  String? get getVal4 => val4;
  void setVal4(String? value) {
    val4 = value;
    notifyListeners();
  }

  String? get getFromCust => fromCust;
  void setFromCust(String? value) {
    fromCust = value;
    notifyListeners();
  }

  String? get getFromSupp => fromSupp;
  void setFromSupp(String? value) {
    fromSupp = value;
    notifyListeners();
  }

  String? get getFromstock => fromStock;
  void setFromStock(String? value) {
    fromStock = value;
    notifyListeners();
  }

  String? get getFromBranch => fromBranch;
  void setFromBranch(String? value) {
    fromBranch = value;
    notifyListeners();
  }

  String? get getFromCustCateg => fromCustCateg;
  void setFromCustCateg(String? value) {
    fromCustCateg = value;
    notifyListeners();
  }

  String? get getFromCateg1 => fromCateg1;
  void setFromCateg1(String? value) {
    fromCateg1 = value;
    notifyListeners();
  }

  String? get getFromCateg2 => fromCateg2;
  void setFromCateg2(String? value) {
    fromCateg2 = value;
    notifyListeners();
  }

  String? get getFromCateg3 => fromCateg3;
  void setFromCateg3(String? value) {
    fromCateg3 = value;
    notifyListeners();
  }

  String? get getToCust => toCust;
  void setToCust(String? value) {
    toCust = value;
    notifyListeners();
  }

  String? get getToSupp => toSupp;
  void setToSupp(String? value) {
    toSupp = value;
    notifyListeners();
  }

  String? get getTostock => toStock;
  void setToStock(String? value) {
    toStock = value;
    notifyListeners();
  }

  String? get getToBranch => toBranch;
  void setToBranch(String? value) {
    toBranch = value;
    notifyListeners();
  }

  String? get getToCustCateg => toCustCateg;
  void setToCustCateg(String? value) {
    toCustCateg = value;
    notifyListeners();
  }

  String? get getToCateg1 => toCateg1;
  void setToCateg1(String? value) {
    toCateg1 = value;
    notifyListeners();
  }

  String? get getToCateg2 => toCateg2;
  void setToCateg2(String? value) {
    toCateg2 = value;
    notifyListeners();
  }

  String? get getToCateg3 => toCateg3;
  void setToCateg3(String? value) {
    toCateg3 = value;
    notifyListeners();
  }

  String? get getFromDate => fromDate;
  void setFromDate(String? value) {
    fromDate = value;
    notifyListeners();
  }

  String? get getToDate => toDate;
  void setToDate(String? value) {
    toDate = value;
  }

  int? get getPage => page;
  void setPage(int? value) {
    page = value;
    notifyListeners();
  }

  bool? get getCheckMultipleBranch => checkMultipleBranch;
  void setCheckMultipleBranch(bool? value) {
    checkMultipleBranch = value;
    notifyListeners();
  }

  bool? get getCheckAllBranch => checkAllBranch;
  void setCheckAllBranch(bool? value) {
    checkAllBranch = value;
    notifyListeners();
  }

  List<String>? get getCodesBranch => codesBranch;
  void setCodesBranch(List<String>? value) {
    codesBranch = value;
    notifyListeners();
  }

  bool? get getCheckMultipleStockCategory1 => checkMultipleStockCategory1;
  void setCheckMultipleStockCategory1(bool? value) {
    checkMultipleStockCategory1 = value;
    notifyListeners();
  }

  bool? get getCheckAllStockCategory1 => checkAllStockCategory1;
  void setCheckAllStockCategory1(bool? value) {
    checkAllStockCategory1 = value;
    notifyListeners();
  }

  List<String>? get getCodesStockCategory1 => codesStockCategory1;
  void setCodesStockCategory1(List<String>? value) {
    codesStockCategory1 = value;
    notifyListeners();
  }

  bool? get getCheckMultipleStockCategory2 => checkMultipleStockCategory2;
  void setCheckMultipleStockCategory2(bool? value) {
    checkMultipleStockCategory2 = value;
    notifyListeners();
  }

  bool? get getCheckAllStockCategory2 => checkAllStockCategory2;
  void setCheckAllStockCategory2(bool? value) {
    checkAllStockCategory2 = value;
    notifyListeners();
  }

  List<String>? get getCodesStockCategory2 => codesStockCategory2;
  void setCodesStockCategory2(List<String>? value) {
    codesStockCategory2 = value;
    notifyListeners();
  }

  bool? get getCheckMultipleStockCategory3 => checkMultipleStockCategory3;
  void setCheckMultipleStockCategory3(bool? value) {
    checkMultipleStockCategory3 = value;
    notifyListeners();
  }

  bool? get getCheckAllStockCategory3 => checkAllStockCategory3;
  void setCheckAllStockCategory3(bool? value) {
    checkAllStockCategory3 = value;
    notifyListeners();
  }

  List<String>? get getCodesStockCategory3 => codesStockCategory3;
  void setCodesStockCategory3(List<String>? value) {
    codesStockCategory3 = value;
    notifyListeners();
  }

  bool? get getCheckMultipleSupplier => checkMultipleSupplier;
  void setCheckMultipleSupplier(bool? value) {
    checkMultipleSupplier = value;
    notifyListeners();
  }

  bool? get getCheckAllSupplier => checkAllSupplier;
  void setCheckAllSupplier(bool? value) {
    checkAllSupplier = value;
    notifyListeners();
  }

  List<String>? get getCodesSupplier => codesSupplier;
  void setCodesSupplier(List<String>? value) {
    codesSupplier = value;
    notifyListeners();
  }

  bool? get getCheckMultipleCustomer => checkMultipleCustomer;
  void setCheckMultipleCustomer(bool? value) {
    checkMultipleCustomer = value;
    notifyListeners();
  }

  bool? get getCheckAllCustomer => checkAllCustomer;
  void setCheckAllCustomer(bool? value) {
    checkAllCustomer = value;
    notifyListeners();
  }

  List<String>? get getCodesCustomer => codesCustomer;
  void setCodesCustomer(List<String>? value) {
    codesCustomer = value;
    notifyListeners();
  }

  bool? get getCheckMultipleCustomerCategory => checkMultipleCustomerCategory;
  void setCheckMultipleCustomerCategory(bool? value) {
    checkMultipleCustomerCategory = value;
    notifyListeners();
  }

  bool? get getCheckAllCustomerCategory => checkAllCustomerCategory;
  void setCheckAllCustomerCategory(bool? value) {
    checkAllCustomerCategory = value;
    notifyListeners();
  }

  List<String>? get getCodesCustomerCategory => codesCustomerCategory;
  void setCodesCustomerCategory(List<String>? value) {
    codesCustomerCategory = value;
    notifyListeners();
  }

  bool? get getCheckMultipleStock => checkMultipleStock;
  void setCheckMultipleStock(bool? value) {
    checkMultipleStock = value;
    notifyListeners();
  }

  bool? get getCheckAllStock => checkAllStock;
  void setCheckAllStock(bool? value) {
    checkAllStock = value;
    notifyListeners();
  }

  List<String>? get getCodesStock => codesStock;
  void setCodesStock(List<String>? value) {
    codesStock = value;
    notifyListeners();
  }

  bool? get getCheckMultipleCompaig => checkMultipleCompaig;
  void setCheckMultipleCompaig(bool? value) {
    checkMultipleCompaig = value;
    notifyListeners();
  }

  List<String>? get getCompaigList => compaigList;
  void setCompaigList(List<String>? value) {
    compaigList = value;
    notifyListeners();
  }

  String? get getCampaignNo => campaignNo;
  void setCampaignNo(String? value) {
    campaignNo = value;
    notifyListeners();
  }

  String? get getModelNo => modelNo;
  void setModelNo(String? value) {
    modelNo = value;
    notifyListeners();
  }

  List<int>? get getOrders => orders;
  void setOrders(List<int>? value) {
    orders = value;
    notifyListeners();
  }

  String? get getViewCodeBarcode => viewCodeBarcode;
  void setViewCodeBarcode(String? value) {
    viewCodeBarcode = value;
    notifyListeners();
  }

  String? get getTransType => transType;
  void setTransType(String? value) {
    transType = value;
    notifyListeners();
  }

  bool? get getAppearBasicUnitEquiv => appearBasicUnitEquiv;
  void setAppearBasicUnitEquiv(bool? value) {
    appearBasicUnitEquiv = value;
    notifyListeners();
  }

  bool? get getAppearInactiveStocks => appearInactiveStocks;
  void setAppearInactiveStocks(bool? value) {
    appearInactiveStocks = value;
    notifyListeners();
  }

  bool? get getAppearInactiveStocksForPurchase =>
      appearInactiveStocksForPurchase;
  void setAppearInactiveStocksForPurchase(bool? value) {
    appearInactiveStocksForPurchase = value;
    notifyListeners();
  }

  bool? get getAppearLocation => appearLocation;
  void setAppearLocation(bool? value) {
    appearLocation = value;
    notifyListeners();
  }

  bool? get getRoundingQty => roundingQty;
  void setRoundingQty(bool? value) {
    roundingQty = value;
    notifyListeners();
  }

  bool? get getRoundingPrice => roundingPrice;
  void setRoundingPrice(bool? value) {
    roundingPrice = value;
    notifyListeners();
  }

  bool? get getTaxIncluded => taxIncluded;
  void setTaxIncluded(bool? value) {
    taxIncluded = value;
    notifyListeners();
  }

  bool? get getAppearDiscount => appearDiscount;
  void setAppearDiscount(bool? value) {
    appearDiscount = value;
    notifyListeners();
  }

  bool? get getUseItemCostPrice => useItemCostPrice;
  void setUseItemCostPrice(bool? value) {
    useItemCostPrice = value;
    notifyListeners();
  }

  bool? get getUsedCostPrice => usedCostPrice;
  void setUsedCostPrice(bool? value) {
    usedCostPrice = value;
    notifyListeners();
  }

  String? get getUsed => used;
  void setUsed(String? value) {
    used = value;
    notifyListeners();
  }

  SalesCriteraProvider(
      {fromDate,
      toDate,
      page,
      checkMultipleBranch,
      checkAllBranch,
      codesBranch,
      checkMultipleStockCategory1,
      checkAllStockCategory1,
      codesStockCategory1,
      checkMultipleStockCategory2,
      checkAllStockCategory2,
      codesStockCategory2,
      checkMultipleStockCategory3,
      checkAllStockCategory3,
      codesStockCategory3,
      checkMultipleSupplier,
      checkAllSupplier,
      codesSupplier,
      checkMultipleCustomer,
      checkAllCustomer,
      codesCustomer,
      checkMultipleCustomerCategory,
      checkAllCustomerCategory,
      codesCustomerCategory,
      checkMultipleStock,
      checkAllStock,
      codesStock,
      checkMultipleCompaig,
      compaigList,
      campaignNo,
      modelNo,
      orders,
      viewCodeBarcode,
      transType,
      appearBasicUnitEquiv,
      appearInactiveStocks,
      appearInactiveStocksForPurchase,
      appearLocation,
      roundingQty,
      roundingPrice,
      taxIncluded,
      appearDiscount,
      useItemCostPrice,
      usedCostPrice,
      used});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['fromDate'] = fromDate ?? "";
    data['toDate'] = toDate ?? "";
    data['page'] = page ?? 1;
    data['checkMultipleBranch'] = checkMultipleBranch ?? false;
    data['checkAllBranch'] = checkAllBranch ?? false;
    data['codesBranch'] = codesBranch ?? [];
    data['checkMultipleStockCategory1'] = checkMultipleStockCategory1 ?? false;
    data['checkAllStockCategory1'] = checkAllStockCategory1 ?? false;
    data['codesStockCategory1'] = codesStockCategory1 ?? [];
    data['checkMultipleStockCategory2'] = checkMultipleStockCategory2 ?? false;
    data['checkAllStockCategory2'] = checkAllStockCategory2 ?? false;
    data['codesStockCategory2'] = codesStockCategory2 ?? [];
    data['checkMultipleStockCategory3'] = checkMultipleStockCategory3 ?? false;
    data['checkAllStockCategory3'] = checkAllStockCategory3 ?? false;
    data['codesStockCategory3'] = codesStockCategory3 ?? [];
    data['checkMultipleSupplier'] = checkMultipleSupplier ?? false;
    data['checkAllSupplier'] = checkAllSupplier ?? false;
    data['codesSupplier'] = codesSupplier ?? [];
    data['checkMultipleCustomer'] = checkMultipleCustomer ?? false;
    data['checkAllCustomer'] = checkAllCustomer ?? false;
    data['codesCustomer'] = codesCustomer ?? [];
    data['checkMultipleCustomerCategory'] =
        checkMultipleCustomerCategory ?? false;
    data['checkAllCustomerCategory'] = checkAllCustomerCategory ?? false;
    data['codesCustomerCategory'] = codesCustomerCategory ?? [];
    data['checkMultipleStock'] = checkMultipleStock ?? false;
    data['checkAllStock'] = checkAllStock ?? false;
    data['codesStock'] = codesStock ?? [];
    data['checkMultipleCompaig'] = checkMultipleCompaig ?? false;
    data['CompaigList'] = compaigList ?? [];
    data['campaignNo'] = campaignNo ?? "";
    data['modelNo'] = modelNo ?? "";
    data['orders'] = orders ?? [];
    data['viewCodeBarcode'] = viewCodeBarcode ?? "";
    data['transType'] = transType ?? "";
    data['appearBasicUnitEquiv'] = appearBasicUnitEquiv ?? false;
    data['appearInactiveStocks'] = appearInactiveStocks ?? false;
    data['appearInactiveStocksForPurchase'] =
        appearInactiveStocksForPurchase ?? false;
    data['appearLocation'] = appearLocation ?? false;
    data['roundingQty'] = roundingQty ?? false;
    data['roundingPrice'] = roundingPrice ?? false;
    data['taxIncluded'] = taxIncluded ?? false;
    data['appearDiscount'] = appearDiscount ?? false;
    data['useItemCostPrice'] = useItemCostPrice ?? false;
    data['usedCostPrice'] = usedCostPrice ?? false;
    data['used'] = used ?? "";
    return data;
  }

  void emptyProvider() {
    fromDate = "";
    toDate = "";
    page = 1;
    checkMultipleBranch = false;
    checkAllBranch = false;
    codesBranch = [];
    checkMultipleStockCategory1 = false;
    checkMultipleStockCategory2 = false;
    checkMultipleStockCategory3 = false;
    checkAllStockCategory1 = false;
    checkAllStockCategory2 = false;
    checkAllStockCategory3 = false;
    codesStockCategory1 = [];
    codesStockCategory2 = [];
    codesStockCategory3 = [];
    checkMultipleStock = false;
    checkMultipleCustomer = false;
    checkMultipleCustomerCategory = false;
    checkMultipleSupplier = false;
    checkAllStock = false;
    checkAllCustomer = false;
    checkAllCustomerCategory = false;
    checkAllSupplier = false;
    codesStock = [];
    codesCustomer = [];
    codesCustomerCategory = [];
    codesSupplier = [];
    campaignNo = "";
    modelNo = "";
    orders = [];
    viewCodeBarcode = "";
    transType = "";
    appearBasicUnitEquiv = false;
    appearInactiveStocksForPurchase = false;
    appearInactiveStocks = false;
    appearDiscount = false;
    useItemCostPrice = false;
    appearLocation = false;
    roundingPrice = false;
    roundingQty = false;
    taxIncluded = false;
    used = "";
    usedCostPrice = false;
    compaigList = [];
    checkMultipleCompaig = false;
    val1 = "";
    val2 = "";
    val3 = "";
    val4 = "";
    fromCateg1 = "";
    toCateg1 = "";
    fromCateg2 = "";
    toCateg2 = "";
    fromCateg3 = "";
    toCateg3 = "";
    fromCust = "";
    toCust = "";
    fromSupp = "";
    toSupp = "";
    fromBranch = "";
    toBranch = "";
    fromStock = "";
    toStock = "";
    fromCustCateg = "";
    toCustCateg = "";
    stkCat1List = [];
    stkCat2List = [];
    stkCat3List = [];
    stocksList = [];
    customerList = [];
    supplierList = [];
    branchesList = [];
    custCatList = [];
    notifyListeners();
  }
}
