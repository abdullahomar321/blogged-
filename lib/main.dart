import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogged/options.dart';
import 'package:blogged/providers/auth.dart';
import 'package:blogged/providers/savedprovider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()..loadPosts()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Blogger(),
    );
  }
}

class Blogger extends StatefulWidget {
  const Blogger({super.key});

  @override
  State<Blogger> createState() => _BloggerState();
}

class _BloggerState extends State<Blogger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const options()), // ✅ goes to options
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Text(
                      'Blogged',
                      style: TextStyle(
                        fontFamily: 'Bubblegum_sans',
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 7
                          ..color = Colors.black,
                      ),
                    ),
                    const Text(
                      'Blogged',
                      style: TextStyle(
                        fontFamily: 'Bubblegum_sans',
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/images/feather-pen.png',
                  height: 120,
                  width: 120,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
