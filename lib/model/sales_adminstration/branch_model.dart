class BranchModel {
  String? branchName;
  String? branchCode;

  BranchModel(this.branchName, this.branchCode);

  BranchModel.fromJson(Map<String, dynamic> branch) {
    branchName =
        branch['text'].toString() == "null" ? "" : branch['text'].toString();
    branchCode =
        branch['value'].toString() == "null" ? "" : branch['value'].toString();
  }

  @override
  String toString() {
    return "$branchCode - $branchName";
  }

  String codeToString() {
    return "$branchCode";
  }
}
