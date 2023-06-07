import 'package:flutter/material.dart';
import 'package:range_mate_app/Screens/Home/home_screen.dart';
import 'package:range_mate_app/Widgets/device_widget.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreen();
}

class _ManagerScreen extends State<ManagerScreen> {
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
            )),
            child: Center(
                child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: const Text(
                      'Manage Devices',
                      style: TextStyle(
                        fontFamily: 'BreeSerif',
                        fontSize: 36,
                        color: Color(0xFF0D5D56),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 25, 0, 0),
                    child: Column(
                      children: [
                        DeviceWidget(),
                      ],
                    )),
                Expanded(
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width * 1,
                      child: const Image(
                        image: AssetImage('images/BuyToken.png'),
                      )),
                  Column(children: [
                    Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Divider(
                                height: 10,
                                thickness: 5,
                                indent: MediaQuery.of(context).size.width * 0.3,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.3,
                                color: Colors.grey))),
                    Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                              },
                              child: const Text('Home',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            )))
                  ])
                ]))
              ],
            ))));
  }
}
