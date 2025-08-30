import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogged/dash.dart';

class likedquotes extends StatefulWidget {
  const likedquotes({super.key});

  @override
  State<likedquotes> createState() => _LikedQuotesState();
}

class _LikedQuotesState extends State<likedquotes> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  List<Map<String, String>> likedQuotes = [];

  @override
  void initState() {
    super.initState();
    _loadLikedQuotes();
  }

  Future<void> _loadLikedQuotes() async {
    final savedData = await storage.read(key: "likedQuotes");
    if (savedData != null) {
      try {
        final decoded = jsonDecode(savedData) as List;
        setState(() {
          likedQuotes =
              decoded.map((e) => Map<String, String>.from(e)).toList();
        });
      } catch (_) {
        likedQuotes = [];
      }
    }
  }

  Future<void> _toggleLike(Map<String, String> quote) async {
    setState(() {
      likedQuotes.removeWhere((q) =>
      q["quote"] == quote["quote"] && q["author"] == quote["author"]);
    });
    await storage.write(key: "likedQuotes", value: jsonEncode(likedQuotes));
  }

  Widget _buildQuoteCard(Map<String, String> quote, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote, color: color, size: 35),
          const SizedBox(height: 12),
          Text(
            "\"${quote['quote']}\"",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "— ${quote['author']}",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red, size: 26),
                onPressed: () => _toggleLike(quote),
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.grey, size: 26),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 80,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const dash()),
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 35,
                color: Colors.white,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Favorites",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: 'Jost',
                  ),
                ),
              )
            ],
          ),

          SliverToBoxAdapter(
            child: Divider(
              color: Colors.grey.shade900,
              thickness: 3,
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (likedQuotes.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "No favorites yet",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  );
                }
                final quote = likedQuotes[index];
                return _buildQuoteCard(
                  quote,
                  index % 2 == 0 ? Colors.yellowAccent : Colors.pinkAccent,
                );
              },
              childCount: likedQuotes.isEmpty ? 1 : likedQuotes.length,
            ),
          ),
        ],
      ),
    );
  }
}
