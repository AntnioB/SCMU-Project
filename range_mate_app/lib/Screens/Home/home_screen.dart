import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    child: const Image(
                      height: 50,
                      image: AssetImage('images/UserProfileButton.png'),
                    )))
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
                  child: Text('Tokens Remaining:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.center,
                  child:Stack(
                    children: <Widget>[ 
                      Center(child:Image(
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
                    ])
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.bottomCenter,
                  child: Text('Tap to Connect',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                )
              ],
            )
            ),
          Expanded(child: Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width * 1,
            child: Image(
              image: const AssetImage('images/BuyToken.png'),
            )
          ))
        ]),
      ),
    );
  }
}
