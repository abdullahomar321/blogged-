import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String? _savedusername;
  String? _savedpw;
  String _bio = "What is a bio?";
  bool _loggedin = false;

  List<Map<String, String>> _posts = [];

  String? get savedusername => _savedusername;
  String? get savedpw => _savedpw;
  String get bio => _bio;
  bool get loggedin => _loggedin;
  List<Map<String, String>> get posts => _posts;

  Future<void> signup(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception("Username and password cannot be empty");
    }

    _savedusername = username;
    _savedpw = password;

    await storage.write(key: 'localUsername', value: username);
    await storage.write(key: 'localPassword', value: password);
    await storage.write(key: 'localBio', value: _bio);

    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    _savedusername ??= await storage.read(key: 'localUsername');
    _savedpw ??= await storage.read(key: 'localPassword');
    _bio = await storage.read(key: 'localBio') ?? _bio;

    await loadPosts();

    if (_savedusername == null || _savedpw == null) {
      return false;
    }

    if (username == _savedusername && password == _savedpw) {
      _loggedin = true;
      notifyListeners();
      return true;
    }

    return false;
  }


  void logout() {
    _loggedin = false;
    notifyListeners();
  }


  Future<bool> tryAutoLogin() async {
    _savedusername = await storage.read(key: 'localUsername');
    _savedpw = await storage.read(key: 'localPassword');
    _bio = await storage.read(key: 'localBio') ?? _bio;

    await loadPosts();

    if (_savedusername != null && _savedpw != null) {
      _loggedin = true;
      notifyListeners();
      return true;
    }
    return false;
  }


  Future<void> changeUsername(String newUsername) async {
    if (newUsername.isEmpty) return;
    _savedusername = newUsername;
    await storage.write(key: 'localUsername', value: newUsername);
    notifyListeners();
  }


  Future<void> changePassword(String newPassword) async {
    if (newPassword.isEmpty) return;
    _savedpw = newPassword;
    await storage.write(key: 'localPassword', value: newPassword);
    notifyListeners();
  }


  Future<void> changeBio(String newBio) async {
    if (newBio.isEmpty) return;
    _bio = newBio;
    await storage.write(key: 'localBio', value: newBio);
    notifyListeners();
  }


  Future<void> addPost(String title, String body) async {
    _posts.add({"title": title, "body": body});
    await storage.write(key: 'posts', value: jsonEncode(_posts));
    notifyListeners();
  }


  Future<void> loadPosts() async {
    String? savedPosts = await storage.read(key: "posts");
    if (savedPosts != null && savedPosts.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedPosts);
        if (decoded is List) {
          _posts = List<Map<String, String>>.from(decoded);
        }
      } catch (_) {
        _posts = [];
      }
    }
    notifyListeners();
  }
  Future<void> deletePost(int index) async {
    if (index < 0 || index >= _posts.length) return;
    _posts.removeAt(index);
    await storage.write(key: "posts", value: jsonEncode(_posts));
    notifyListeners();
  }

}
