import 'package:blogged/add%20quote.dart';
import 'package:blogged/feed.dart';
import 'package:blogged/likedquotes.dart';
import 'package:blogged/security.dart';
import 'package:blogged/savedquotes.dart';
import 'package:blogged/userinfo.dart';
import 'package:flutter/material.dart';
import 'package:blogged/main.dart';

class dash extends StatefulWidget {
  const dash({super.key});

  @override
  State<dash> createState() => _dashState();
}

class _dashState extends State<dash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 80,
            pinned: true,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'DashBoard',
                style: TextStyle(
                  fontSize: 51,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    const BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey,
                    )
                  ],
                ),
                child: Card(
                  color: Colors.grey.shade900,
                  elevation: 5,
                  child: GridView.count(
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildOptions(Icons.feed, "Feed", () {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>feed()));
                      }),
                      _buildOptions(Icons.favorite, "Liked Quotes", () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>likedquotes()));
                      }),
                      _buildOptions(Icons.person, "Profile", () {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>user()));
                      }),
                      _buildOptions(Icons.security, "Security", () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>profile()));
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade900,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: const Text(
                'Menu',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => MyApp()));
                },
                icon: const Icon(
                  Icons.home_filled,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jost',
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => savedquotes()));
                },
                icon: const Icon(
                  Icons.save_as_sharp,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              title: const Text(
                'Saved Blogs',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jost',
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AddQuote()));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              title: const Text(
                'Post Blog',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jost',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildOptions(IconData icon, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: 40,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Jost',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
