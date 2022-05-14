class LoginUserModel {
  String? displayName;
  String? email;
  String? photoURL;
  String? userId;

  LoginUserModel({
    this.displayName,
    this.email,
    this.photoURL,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
    };
  }
}
