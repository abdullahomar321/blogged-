import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SavedProvider with ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _key = "saved_posts";

  List<Map<String, String>> _posts = [];
  List<Map<String, String>> get posts => _posts;


  Future<void> loadPosts() async {
    String? savedData = await _storage.read(key: _key);
    if (savedData != null) {
      _posts = List<Map<String, String>>.from(jsonDecode(savedData));
    }
    notifyListeners();
  }


  Future<void> addPost(String title, String body) async {
    _posts.add({"title": title, "body": body});
    await _storage.write(key: _key, value: jsonEncode(_posts));
    notifyListeners();
  }


  Future<void> deletePost(int index) async {
    if (index < _posts.length) {
      _posts.removeAt(index);
      await _storage.write(key: _key, value: jsonEncode(_posts));
      notifyListeners();
    }
  }


  Future<void> clearPosts() async {
    _posts.clear();
    await _storage.delete(key: _key);
    notifyListeners();
  }
}
