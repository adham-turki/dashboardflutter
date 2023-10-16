class AgingModel {
  double? total;
  AgingModel(this.total);
  AgingModel.fromJson(Map<String, dynamic> aging) {
    total = aging['total'].toString() == 'null' ? 0.0 : aging['total'];
  }
}
