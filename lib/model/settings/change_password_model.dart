class ChangePasswordModel {
  String? oldPass;
  String? newPass;
  ChangePasswordModel(this.oldPass, this.newPass);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};

    user['oldPass'] = oldPass;
    user['newPass'] = newPass;

    return user;
  }
}
