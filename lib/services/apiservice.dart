import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://dummyjson.com";

  static Future<List<Map<String, String>>> fetchQuotes({int limit = 10, int skip = 0}) async {
    final response = await http.get(Uri.parse("$baseUrl/quotes?limit=$limit&skip=$skip"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List quotes = data['quotes'];
      return quotes.map<Map<String, String>>((q) => {
        "quote": q['quote'].toString(),
        "author": q['author'].toString(),
      }).toList();
    } else {
      throw Exception("Failed to load quotes");
    }
  }
}
