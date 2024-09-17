import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../../routes/app_routes.dart';

class Clearfiy extends StatefulWidget {
  const Clearfiy({super.key});

  @override
  State<Clearfiy> createState() => _ClearfiyState();
}

class _ClearfiyState extends State<Clearfiy> {
  int remainingSeconds = 10;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds--;
        if (remainingSeconds == 0) {
          timer.cancel();
          Get.offAllNamed(Routes.ROOT);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/clearfiy.png"),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            "$remainingSeconds",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff1263AA),
            ),
          ),
        ),
      ),
    );
  }
}
