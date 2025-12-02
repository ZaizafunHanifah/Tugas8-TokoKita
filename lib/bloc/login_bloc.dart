import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/login.dart';

class LoginApi {
  static Future<Login> connect(String email, String password) async {
    // Test account for development
    if (email == "test@example.com" && password == "123456") {
      return Login(
        code: 200,
        status: true,
        token: "fake_token_123",
        userID: 1,
        userEmail: "test@example.com",
      );
    }

    String apiURL = ApiUrl.login;
    var body = {
      "email": email,
      "password": password,
    };
    var response = await Api().postJsonWithoutToken(apiURL, body);
    var jsonObj = json.decode(response);
    return Login.fromJson(jsonObj);
  }
}