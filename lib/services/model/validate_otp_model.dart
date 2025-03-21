class ValidateOtpModel {
  List<String>? email;
  List<String>? otp;

  ValidateOtpModel({this.email, this.otp});

  ValidateOtpModel.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
    otp = json['otp'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['otp'] = this.otp;
    return data;
  }
}