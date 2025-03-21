class EmailVerificationModel {  // Make sure the class name is correct
  String? message;
  String? email;

  EmailVerificationModel({this.message, this.email});

  factory EmailVerificationModel.fromJson(Map<String, dynamic> json) {
    return EmailVerificationModel(
      message: json['message'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'email': email,
    };
  }
}
