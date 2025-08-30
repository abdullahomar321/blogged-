import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogged/options.dart';
import 'package:blogged/providers/auth.dart';
import 'package:blogged/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController pwcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const options()),
                );
              },
              icon: const Icon(Icons.arrow_back, size: 35, color: Colors.white),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          const SliverToBoxAdapter(
            child: Icon(Icons.app_registration,
                size: 150, color: Colors.white),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: usernamecontroller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter Username i.e user123_90',
                      hintStyle: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'AtkinsonHyperlegible',
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                    ),
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: pwcontroller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter PassWord',
                      hintStyle: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'AtkinsonHyperlegible',
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                    ),
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 60),
                    backgroundColor: Colors.blue.shade700,
                  ),
                  onPressed: () async {
                    final username = usernamecontroller.text.trim();
                    final password = pwcontroller.text.trim();

                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields',style: TextStyle(
                            fontSize: 22,
                          ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }


                    await Provider.of<AuthProvider>(context, listen: false)
                        .signup(username, password);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context)=>login())
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'AtkinsonHyperlegible',
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
