class ComputerModel {
  String? computer;

  ComputerModel({this.computer});

  factory ComputerModel.fromJson(Map<String, dynamic> json) {
    return ComputerModel(
      computer: json['computer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'computer': computer,
    };
  }

  @override
  String toString() {
    return computer ?? "";
  }
}
