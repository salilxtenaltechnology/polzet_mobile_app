class LoginModel {
  final String? message;
  final String? accessToken;
  final String? refreshToken;

  LoginModel({this.message, this.accessToken, this.refreshToken});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        message: json['message'],
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}
