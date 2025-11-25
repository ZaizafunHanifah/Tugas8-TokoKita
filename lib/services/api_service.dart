// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../model/produk.dart';
import '../model/login.dart';
import '../model/registrasi.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api'; // Adjust as needed

  static Future<List<Produk>> listProduk() async {
    if (useMock) {
      // Mock data
      await Future.delayed(const Duration(seconds: 1));
      return [
        Produk(id: '1', kodeProduk: 'P001', namaProduk: 'Produk 1', hargaProduk: 10000),
        Produk(id: '2', kodeProduk: 'P002', namaProduk: 'Produk 2', hargaProduk: 20000),
      ];
    } else {
      final response = await http.get(Uri.parse('$baseUrl/produk'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data'] as List).map((e) => Produk.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load produk');
      }
    }
  }

  static Future<Produk?> createProduk(Produk produk) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return Produk(id: '3', kodeProduk: produk.kodeProduk, namaProduk: produk.namaProduk, hargaProduk: produk.hargaProduk);
    } else {
      final response = await http.post(
        Uri.parse('$baseUrl/produk'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(produk.toJson()),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Produk.fromJson(data['data']);
      } else {
        return null;
      }
    }
  }

  static Future<Produk?> updateProduk(String id, Produk produk) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return produk..id = id;
    } else {
      final response = await http.put(
        Uri.parse('$baseUrl/produk/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(produk.toJson()),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Produk.fromJson(data['data']);
      } else {
        return null;
      }
    }
  }

  static Future<bool> deleteProduk(String id) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } else {
      final response = await http.delete(Uri.parse('$baseUrl/produk/$id'));
      return response.statusCode == 200;
    }
  }

  static Future<Login> login(String email, String password) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return Login(code: 200, status: true, token: 'mock_token', userID: 1, userEmail: email);
    } else {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Login.fromJson(data);
      } else {
        return Login(code: response.statusCode, status: false);
      }
    }
  }

  static Future<Registrasi> registrasi(String nama, String email, String password) async {
    if (useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return Registrasi(code: 201, status: true, data: 'Registrasi berhasil');
    } else {
      final response = await http.post(
        Uri.parse('$baseUrl/registrasi'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nama': nama, 'email': email, 'password': password}),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Registrasi.fromJson(data);
      } else {
        return Registrasi(code: response.statusCode, status: false, data: 'Registrasi gagal');
      }
    }
  }
}