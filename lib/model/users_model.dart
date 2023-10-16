class UserModel {
  String? userName;
  String? password;

  UserModel(this.userName, this.password);

  UserModel.fromJson(Map<String, dynamic> user) {
    userName = user['username'].toString() == "null"
        ? ""
        : user['username'].toString();
    password = user['password'].toString() == "null"
        ? ""
        : user['password'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};

    user['username'] = userName;
    user['password'] = password;

    return user;
  }
}
