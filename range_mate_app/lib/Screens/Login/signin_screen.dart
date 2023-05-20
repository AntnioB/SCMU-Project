import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      List.generate(3, (i) => TextEditingController());


  void showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(message, style: const TextStyle(color: Colors.red)
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  void dispose() {
    for (final controller in _controller) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> signUp() async {
    final email = _controller[0].text;
    final password = _controller[1].text;
    final confirmPassword = _controller[2].text;


    if(email == '' || password == ''){
      showError("Please fill in empty fields!");
    } else if (password != confirmPassword) {
      showError("Passwords do not match!");
    } else {

      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );


        CollectionReference users = FirebaseFirestore.instance.collection('users');
        users.add({
          'id': credential.user?.uid,
          'email': email,
          'tokens': 3
        });

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Colors.white,
              content: Text('Account was successfully created!', style: TextStyle(color: Colors.green)
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );

        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const LoginScreen()));

      } on FirebaseAuthException catch (e) {
        switch(e.code){
          case('weak-password'):
            showError('The password provided is too weak.');
            break;
          case('email-already-in-use'):
            showError('The account already exists for that email.');
            break;
          case('invalid-email'):
            showError('Email is badly formatted');
        }
      } catch (e) {
        showError(e.toString());
      }

    }

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
                  const Text(
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
                      controller: _controller[1],
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
                      controller: _controller[2],
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: const InputDecoration(
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
