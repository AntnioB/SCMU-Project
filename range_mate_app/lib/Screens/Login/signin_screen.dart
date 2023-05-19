import 'package:flutter/material.dart';
import 'package:range_mate_app/Screens/Login/login_screen.dart';

enum FormData {
  username,
  email,
  password,
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final List<TextEditingController> _controller =
      List.generate(4, (i) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _controller) {
      controller.dispose();
    }
    super.dispose();
  }

  void signUp() {
    final username = _controller[0].text;
    final email = _controller[1].text;
    final password = _controller[2].text;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const LoginScreen()));
    //TODO: Add sign up logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'BreeSerif',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _controller[0],
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _controller[1],
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _controller[2],
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: _controller[3],
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: SizedBox(
                            width: 150,
                            child:ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF0D5D56)),
                            ),
                            onPressed: () {
                              signUp();
                            },
                            child: const Text(
                              'Create Account',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))),
                ]),
          )),
    );
  }
}
