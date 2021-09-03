class UserModel {
  String? uid;
  String? name;
  String? keyName;
  String? email;
  String? creationTime;
  String? lastSignInTime;
  String? photoUrl;
  String? status;
  String? updatedTime;

  UserModel(
      {this.uid,
      this.name,
      this.keyName,
      this.email,
      this.creationTime,
      this.lastSignInTime,
      this.photoUrl,
      this.status,
      this.updatedTime});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    keyName = json['keyName'];
    email = json['email'];
    creationTime = json['creationTime'];
    lastSignInTime = json['lastSignInTime'];
    photoUrl = json['photoUrl'];
    status = json['status'];
    updatedTime = json['updatedTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['keyName'] = keyName;
    data['email'] = email;
    data['creationTime'] = creationTime;
    data['lastSignInTime'] = lastSignInTime;
    data['photoUrl'] = photoUrl;
    data['status'] = status;
    data['updatedTime'] = updatedTime;
    return data;
  }
}
