class LoginResponseModel{
  final String token;
  final String error;
  LoginResponseModel({this.token,this.error});

  factory LoginResponseModel.fromjson(Map<String, dynamic> json){
    return LoginResponseModel(
        token: json["token"] != null ? json["token"] : "",
        error: json["error"] != null ? json["error"] : ""
    );
  }

}
class LoginRequestModel{
  String userId;
  String password;
  LoginRequestModel({this.userId,this.password});
  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'userId': userId.trim(),
      'password': password.trim()
    };
    return map;
  }
}