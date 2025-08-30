import 'dart:convert';
import 'package:blogged/dash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class savedquotes extends StatefulWidget {
  const savedquotes({super.key});

  @override
  State<savedquotes> createState() => _SavedQuotesState();
}

class _SavedQuotesState extends State<savedquotes> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  List<Map<String, String>> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final savedData = await storage.read(key: "posts");
    if (savedData != null && savedData.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedData);
        if (decoded is List) {
          setState(() {
            posts = decoded.map((e) => Map<String, String>.from(e)).toList();
          });
        } else if (decoded is Map) {
          setState(() {
            posts = [Map<String, String>.from(decoded)];
          });
        }
      } catch (_) {
        setState(() {
          posts = [];
        });
      }
    }
  }

  Future<void> _deletePost(int index) async {
    setState(() {
      posts.removeAt(index);
    });
    await storage.write(key: "posts", value: jsonEncode(posts));
  }

  Widget _buildQuoteCard(String title, String body, Color color, int index) {
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
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 26),
                onPressed: () => _deletePost(index),
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
                  "Saved Quotes",
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
                if (posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "No saved quotes yet",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  );
                }
                final post = posts[index];
                return _buildQuoteCard(
                  post["title"] ?? "Untitled",
                  post["body"] ?? "",
                  index % 2 == 0 ? Colors.yellowAccent : Colors.pinkAccent,
                  index,
                );
              },
              childCount: posts.isEmpty ? 1 : posts.length,
            ),
          ),
        ],
      ),
    );
  }
}
