import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/registrasi.dart';

class RegistrasiBloc {
    static Future<Registrasi?> registrasi(
      {required String nama, required String email, required String password}) async {
    String apiURL = ApiUrl.register;

    var body = {
      "nama": nama,
      "email": email,
      "password": password,
    };

    var response = await Api().postJsonWithoutToken(apiURL, body);
    var jsonObj = json.decode(response);
    return Registrasi.fromJson(jsonObj);
  }
}