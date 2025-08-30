import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blogged/dash.dart';
import 'package:blogged/providers/auth.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Future<void> _showChangeDialog(
      BuildContext context, String field, Function(String) onSave) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          "Change $field",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          obscureText: field == "Password",
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$field updated successfully"),
                  backgroundColor: Colors.green,
                ));
              }
            },
            child: const Text("Save",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
                    context, MaterialPageRoute(builder: (context) => dash()));
              },
              icon: const Icon(Icons.arrow_back, size: 35, color: Colors.white),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Security',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.blueAccent,
                  ),
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Divider(thickness: 3, color: Colors.grey.shade900),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
          const SliverToBoxAdapter(
            child: Icon(Icons.security, size: 140, color: Colors.white),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 220,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.grey.shade900,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.5,
                      color: Colors.grey.shade900,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Username",
                        style:
                        TextStyle(color: Colors.grey, fontSize: 18)),
                    Text(
                      auth.savedusername ?? "Not set",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("Password",
                        style:
                        TextStyle(color: Colors.grey, fontSize: 18)),
                    Text(
                      auth.savedpw ?? "Not set",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 45)),

          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(400, 60),
                  ),
                  onPressed: () => _showChangeDialog(
                    context,
                    "Password",
                        (newPassword) =>
                        context.read<AuthProvider>().changePassword(newPassword),
                  ),
                  child: const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jost',
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(400, 60),
                  ),
                  onPressed: () => _showChangeDialog(
                    context,
                    "Username",
                        (newUsername) =>
                        context.read<AuthProvider>().changeUsername(newUsername),
                  ),
                  child: const Text(
                    "Change Username",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Jost',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
