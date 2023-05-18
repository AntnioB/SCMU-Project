import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:range_mate_app/Screens/User/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void userProfileButtonPress(){
    //stderr.writeln('User Profile Button Pressed');
    log("User Profile Button Pressed");
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const UserProfileScreen()));
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
        child: Column(children: [
          Row(children: [
            Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
                child: Image(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.45,
                  image: const AssetImage('images/RangeMate2.png'),
                )),
            Expanded(
                child: Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
                    child:GestureDetector(
                      onTap: () {userProfileButtonPress();},
                      child: const Image(
                      height: 50,
                      image: AssetImage('images/UserProfileButton.png'),
                    ))))
          ]),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          ),
          Container(
              height: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3)),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      alignment: Alignment.topCenter,
                      child:const Text('Tokens Remaining:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child: Stack(children: <Widget>[
                        const Center(
                            child: Image(
                                width: 200,
                                image: AssetImage('images/Coin.png'))),
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 75, 30, 0),
                            alignment: Alignment.bottomCenter,
                            child: Text('3',
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)))
                      ])),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.bottomCenter,
                      child: const Text('Tap to Connect',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)))
                ],
              )),
          Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
            Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width * 1,
                child: const Image(
                  image: AssetImage('images/BuyToken.png'),
                )),
            Column(children: [
              Expanded(child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 10),
                  child: Divider(
                      height: 10,
                      thickness: 5,
                      indent: MediaQuery.of(context).size.width * 0.3,
                      endIndent: MediaQuery.of(context).size.width * 0.3,
                      color: Colors.grey))),
              Expanded(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child: const Text('Buy Tokens',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))))
            ])
          ]))
        ]),
      ),
    );
  }
}
