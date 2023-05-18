import 'package:flutter/material.dart';
import 'package:range_mate_app/Screens/Home/home_screen.dart';
import 'package:range_mate_app/Screens/Login/signin_screen.dart';

enum FormData {
  username,
  password,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<TextEditingController> _controller =
      List.generate(2, (i) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _controller) {
      controller.dispose();
    }
    super.dispose();
  }

  void login() {
    final username = _controller[0].text;
    final password = _controller[1].text;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const HomeScreen()));
    //TODO: Add login logic
  }

  void signUp() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const SignInScreen()));
    //TODO: Add sign up logic
  }

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "RangeMate",
                    style: TextStyle(color: Color(0xFF0D5D56), fontFamily: 'BreeSerif'  ,fontSize: 50),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TextField(
                                controller: _controller[0],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User Name',
                                  hintText: 'Enter your User Name.',
                                ),
                              )),
                          Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: TextField(
                                controller: _controller[1],
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Enter your Password.',
                                ),
                              )),
                          SizedBox(
                            width: 150,
                            child:ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF0D5D56)),
                            ),
                            onPressed: () {
                              login();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                          SizedBox(
                            width: 150,
                            child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF0D5D56)),
                            ),
                            onPressed: () {
                              signUp();
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                        ]),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
