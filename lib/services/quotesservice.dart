import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String baseUrl = "https://dummyjson.com";

  static Future<List<Map<String, String>>> fetchQuotes({
    int limit = 5,
    int skip = 0,
  }) async {
    final url = Uri.parse("$baseUrl/quotes?limit=$limit&skip=$skip");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List quotes = data['quotes'];

      return quotes
          .map<Map<String, String>>((q) => {
        "quote": q['quote'].toString(),
        "author": q['author'].toString(),
      })
          .toList();
    } else {
      throw Exception("❌ Failed to load quotes");
    }
  }
}
