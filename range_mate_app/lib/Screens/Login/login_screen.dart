import 'package:flutter/material.dart';

enum FormData {
  username,
  password,
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              const Color(0xFF8FD5A6).withOpacity(0.8),
              const Color(0xFF329F5B),
              const Color(0xFF0C8346),
              const Color(0xFF0D5D56)
            ],
          ),
        ),
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3)),
              child: Column(
                children: const [
                  Text(
                    "RangeMate",
                    style: TextStyle(color: Color(0xFF0D5D56), fontSize: 50),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
