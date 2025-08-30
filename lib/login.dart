import 'package:blogged/dash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogged/options.dart';
import 'package:blogged/providers/auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  bool isLoading = false;
  bool obscurePw = true;

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
                  MaterialPageRoute(builder: (context) => const options()),
                );
              },
              icon: const Icon(Icons.arrow_back, size: 35, color: Colors.white),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),

          const SliverToBoxAdapter(
            child: Icon(Icons.login_rounded, size: 150, color: Colors.white),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 60)),

          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Username Field
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter Username',
                      hintStyle: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'AtkinsonHyperlegible',
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                    ),
                    style: const TextStyle(fontSize: 25),
                  ),
                ),

                // Password Field
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: pwController,
                    obscureText: obscurePw,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter Password',
                      hintStyle: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'AtkinsonHyperlegible',
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePw ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey.shade700,
                        ),
                        onPressed: () {
                          setState(() => obscurePw = !obscurePw);
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 25),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 60),
                    backgroundColor: Colors.blue.shade700,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                    final username = usernameController.text.trim();
                    final password = pwController.text.trim();

                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter both fields',
                            style: TextStyle(fontSize: 22),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    setState(() => isLoading = true);

                    final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);

                    final success =
                    await authProvider.login(username, password);

                    setState(() => isLoading = false);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Login Successful 🎉',
                            style: TextStyle(fontSize: 22),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const dash()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Invalid Username or Password ❌',
                            style: TextStyle(fontSize: 22),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Login',
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
