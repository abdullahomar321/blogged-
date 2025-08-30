import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogged/dash.dart';
import 'package:blogged/services/quotesservice.dart';

class feed extends StatefulWidget {
  const feed({super.key});

  @override
  State<feed> createState() => _feedState();
}

class _feedState extends State<feed> {
  List<Map<String, String>> visibleQuotes = [];
  List<Map<String, String>> likedQuotes = []; // store liked quotes
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  int limit = 5;
  int skip = 0;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadLikedQuotes();
    _fetchQuotes();
  }

  Future<void> _loadLikedQuotes() async {
    final savedData = await storage.read(key: "likedQuotes");
    if (savedData != null) {
      try {
        final decoded = jsonDecode(savedData) as List;
        setState(() {
          likedQuotes = decoded.map((e) => Map<String, String>.from(e)).toList();
        });
      } catch (_) {
        likedQuotes = [];
      }
    }
  }

  Future<void> _toggleLike(Map<String, String> quote) async {
    final isLiked = likedQuotes.any((q) =>
    q["quote"] == quote["quote"] && q["author"] == quote["author"]);

    setState(() {
      if (isLiked) {
        likedQuotes.removeWhere((q) =>
        q["quote"] == quote["quote"] && q["author"] == quote["author"]);
      } else {
        likedQuotes.add(quote);
      }
    });

    await storage.write(key: "likedQuotes", value: jsonEncode(likedQuotes));
  }

  bool _isLiked(Map<String, String> quote) {
    return likedQuotes.any(
            (q) => q["quote"] == quote["quote"] && q["author"] == quote["author"]);
  }

  Future<void> _fetchQuotes() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    try {
      final newQuotes =
      await QuoteService.fetchQuotes(limit: limit, skip: skip);

      if (newQuotes.isEmpty) {
        setState(() => hasMore = false);
      } else {
        setState(() {
          visibleQuotes.addAll(newQuotes);
          skip += limit;
        });
      }
    } catch (e) {
      debugPrint("Error fetching quotes: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
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
                icon: Icon(
                  _isLiked(quote) ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked(quote) ? Colors.red : Colors.grey,
                  size: 26,
                ),
                onPressed: () => _toggleLike(quote),
              ),
            ],
          )
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
            expandedHeight: 70,
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const dash()),
                );
              },
              icon: const Icon(Icons.arrow_back, size: 35, color: Colors.white),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Quotes",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
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
                if (index < visibleQuotes.length) {
                  return _buildQuoteCard(
                    visibleQuotes[index],
                    index % 2 == 0
                        ? Colors.yellowAccent
                        : Colors.pinkAccent,
                  );
                } else if (index == visibleQuotes.length) {
                  if (!hasMore) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "No more quotes",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: isLoading
                        ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(
                          color: Colors.blueAccent),
                    )
                        : ElevatedButton(
                      onPressed: _fetchQuotes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: const Text(
                        "Load More",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                return null;
              },
              childCount: visibleQuotes.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
