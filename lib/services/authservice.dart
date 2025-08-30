import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "https://dummyjson.com";
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await storage.write(key: "token", value: data["token"]);
      await storage.write(key: "userId", value: data["id"].toString());
      await storage.write(key: "username", value: data["username"]);

      return data;
    } else {
      throw Exception("Login failed. Please check your credentials.");
    }
  }

  static Future<Map<String, dynamic>> signupUser(
      Map<String, String> userData) async {
    final url = Uri.parse("$baseUrl/users/add");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("❌ Signup failed. Try again.");
    }
  }

  static Future<void> logoutUser() async {
    await storage.deleteAll();
  }

  static Future<bool> isLoggedIn() async {
    final token = await storage.read(key: "token");
    return token != null;
  }

  static Future<String?> getUsername() async {
    return await storage.read(key: "username");
  }
}
