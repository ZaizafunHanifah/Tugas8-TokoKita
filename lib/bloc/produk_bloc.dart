import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    var token = await UserInfo().getToken();
    if (token == "fake_token_123") {
      // Return fake data for test account
      return [
        Produk(id: "1", kodeProduk: "P001", namaProduk: "Test Product 1", hargaProduk: 10000),
        Produk(id: "2", kodeProduk: "P002", namaProduk: "Test Product 2", hargaProduk: 20000),
      ];
    }

    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response);
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks = [];
    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    return produks;
  }

  static Future<Produk> addProduk({Produk? produk}) async {
    var token = await UserInfo().getToken();
    if (token == "fake_token_123") {
      // Return fake added product
      return Produk(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        kodeProduk: produk!.kodeProduk,
        namaProduk: produk.namaProduk,
        hargaProduk: produk.hargaProduk,
      );
    }

    String apiUrl = ApiUrl.createProduk;

    var body = {
      "kode_produk": produk!.kodeProduk,
      "nama_produk": produk!.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response);
    return Produk.fromJson(jsonObj['data']);
  }

  static Future updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
    print(apiUrl);

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString()
    };
    print("Body: $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response);
    return jsonObj['status'];
  }

  static Future<bool> deleteProduk({int? id}) async {
    String apiUrl = ApiUrl.deleteProduk(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
