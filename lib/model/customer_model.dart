class CustomerModel {
  String? text;
  String? value;

  CustomerModel({
    this.text,
    this.value,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      text: json['text'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }

  @override
  String toString() {
    return text ?? "";
  }
}
