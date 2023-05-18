import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
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
          )
        ),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: const Text(
              'RangeMate User Info',
              style: TextStyle(
                fontFamily: 'BreeSerif',
                fontSize: 36,
                color: Color(0xFF0D5D56),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            )),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: CircleAvatar(
              radius: 125,
              backgroundImage: AssetImage('images/UserProfile.jpg'),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              children: [
                Row(children:[
              const Text('UserName',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),),]),
              Row(children:[
              Text('realDonaldTrump'),]),
              Divider(
                thickness: 3,
                color: Colors.grey,
              ),
              Row(children:[
              Text('Email',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),),]),
              Row(children:[
              Text('realDonaldTrump@gmail.com'),]),
              Divider(
                thickness: 3,
                color: Colors.grey,
              ),
            ]),
          )
        ]),
        ));
  }
}