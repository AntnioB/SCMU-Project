import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:range_mate_app/Screens/Bluetooth/connect.dart';
import 'package:range_mate_app/Screens/User/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController purchaseTokensNum;

  void userProfileButtonPress(){
    //stderr.writeln('User Profile Button Pressed');
    log("User Profile Button Pressed");
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const UserProfileScreen()));
  }
  
  Future<String> getTokenNum() async{
    var user = FirebaseAuth.instance.currentUser;
    String res = "-1";
    await FirebaseFirestore.instance.collection('users').where("id", isEqualTo: user?.uid).get().then(
            (query) => {
               res = query.docs.first.get("tokens").toString()
            }
    );
    return res;
  }

  updateToken(User? user,int value, int valToSum) async{
    int tokens = valToSum + value;
    await FirebaseFirestore.instance.collection('users').where("id", isEqualTo: user?.uid).get().then(
      (query) => {
        FirebaseFirestore.instance.collection('users').doc(query.docs.first.id).update(
            {
              "tokens": tokens
            })
      }
      );
  }
  purchaseTokens() async {
    User? user = FirebaseAuth.instance.currentUser;
    int valToSum = int.parse(purchaseTokensNum.value.text);
    getTokenNum().then(
            (value) => {
              updateToken(user, int.parse(value), valToSum)
            }
    );
    purchaseTokensNum.clear();
    Navigator.of(context).pop();
  }

  cancel(){
    purchaseTokensNum.clear();
    Navigator.of(context).pop();
  }

 Future showPaymentAlert(BuildContext context) {return showDialog(
      context: context,
      builder: (BuildContext context) { return
        AlertDialog(
          title: const Text('Simulate buying tokens'),
          content: TextField(
            controller: purchaseTokensNum,
            maxLength: 1,
              decoration: const InputDecoration(
                  labelText: "Enter amount to purchase"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly
              ]),
          actions: [
            TextButton(
                onPressed: () => purchaseTokens(), child: const Text('Purchase', style: TextStyle(color: Colors.green),)),
            TextButton(onPressed: () => cancel(), child: const Text('Cancel', style: TextStyle(color: Colors.red)))
          ],
        );
      });
  }

  @override
  void initState() {
    super.initState();
    // this should not be done in build method.
    getTokenNum();
    purchaseTokensNum = TextEditingController();
  }

  @override
  void dispose(){
    purchaseTokensNum.dispose();
    super.dispose();
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
                            child: FutureBuilder<String>(
                                  future: getTokenNum(),

                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                    Text child;
                                    if(snapshot.hasData){
                                      child = Text(snapshot.data ?? '',
                                          style: const TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black));
                                    }
                                    else if(snapshot.hasError) {
                                      print(snapshot.error);
                                      child = const Text('error',
                                          style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black));
                                    }
                                    else {
                                      child = const Text('',
                                          style: TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black));
                                    }
                                    return child;
                                  }
                            ),

                        )])),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.bottomCenter,
                      child:  TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const FlutterBlueApp())); },
                        child: const Text('Tap to Connect'),
                      )
                  )
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
                      child: TextButton(
                          onPressed: () {
                            showPaymentAlert(context);
                          },
                          child: const Text('Buy Tokens',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)))))
            ])
          ]))
        ]),
      ),
    );
  }


}
