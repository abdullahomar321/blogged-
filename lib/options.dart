import 'package:blogged/login.dart';
import 'package:blogged/main.dart';
import 'package:blogged/signup.dart';
import 'package:flutter/material.dart';


class options extends StatefulWidget {
  const options({super.key});

  @override
  State<options> createState() => _optionsState();
}

class _optionsState extends State<options> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            leading: IconButton(onPressed: (){
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=>Blogger()));
            }, icon: Icon(Icons.arrow_back,size: 35,color: Colors.white,)
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(style: ElevatedButton.styleFrom(
                  minimumSize: Size(400, 60),
                    backgroundColor: Colors.white,
                  ),onPressed: (){
                     Navigator.pushReplacement(context,
                         MaterialPageRoute(builder: (context)=>Signup()));
                  }, child: Text('Sign Up',style: TextStyle(
                    fontFamily: 'AtkinsonHyperlegible',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  ),
                  ),
                  SizedBox(height:40 ,),
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    minimumSize: Size(400, 60),
                    backgroundColor: Colors.white,
                  ),onPressed: (){
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>login()));

                  }, child: Text('Log In',style: TextStyle(
                    fontFamily: 'AtkinsonHyperlegible',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
