import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// 0, 105, 255, 1
// 66, 143, 255, 1
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final Color blue = Color.fromRGBO(0, 105, 255, 1);
  final Color lightBlue = Color.fromRGBO(66, 143, 255, 1);
  final Color white = Colors.white;

  double height = 90;
  double width = 225;

  double iconWidth = 40;

  final int firstAnimation = 300;
  final int secondAnimation = 8000;

  AnimationController animationController;
  AnimationController animationController2;

  String t1 = 'Publish';
  String t2 = 'Loading';

  double sW = 0;

  double val;

  IconData icon = Icons.keyboard_arrow_up;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: firstAnimation));
    animationController2 = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: secondAnimation),
        lowerBound: 1,
        upperBound: 15);
  }

  void startAnimation() {
    animationController.forward();

    animationController2.forward();
  }

  void resetAnimation() {
    animationController.reset();

    animationController2.reset();
  }

  @override
  Widget build(BuildContext context) {
    print(val);
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            startAnimation();
            setState(() {
              width = width == 225 ? 240 : 225;
            });
            Timer(Duration(milliseconds: secondAnimation), () {
              setState(() {
                t1 = 'Loading';
                t2 = 'Done';
                icon = Icons.done;
                width = 225;
                animationController.reset();
                animationController.forward();
                sW = 45;
              });
            });
            Timer(Duration(milliseconds: secondAnimation + 2000), () {
              resetAnimation();
              setState(() {
                sW = 0;
                t1 = 'Publish';
                t2 = 'Loading';
                icon = Icons.keyboard_arrow_up;
              });
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: firstAnimation),
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //* ICON
                AnimatedBuilder(
                  animation: animationController2,
                  builder: (context, child) {
                    val = animationController2.value;
                    return Container(
                      width: iconWidth + 40,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: sW,
                              height: sW,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white.withOpacity(.4),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: val == 1 ? 1 : 0,
                            child: Icon(Icons.cloud,
                                color: white.withOpacity(.4), size: 38),
                          ),
                          Positioned(
                            top: val.toInt() % 2 == 0
                                ? (height * cos(val * 180 * (pi / 180)) * -1)
                                : (-30),
                            child: Icon(Icons.cloud,
                                size: 34, color: white.withOpacity(.4)),
                          ),
                          Positioned(
                            top: 10 *
                                cos(animationController2.value *
                                    90 *
                                    (pi / 180)),
                            height: height,
                            child: Icon(icon,
                                size: 40, color: white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                //* TEXt
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            top: 4,
                            child: Container(
                              alignment: Alignment.center,
                              child: Transform(
                                transform: Matrix4.translationValues(
                                    0, 20 * animationController.value, 0),
                                child: Opacity(
                                  opacity: animationController.value,
                                  child: Text(
                                    t2,
                                    style: TextStyle(
                                      color: white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  0, 20 * animationController.value, 0),
                              child: Opacity(
                                opacity: 1 - animationController.value,
                                child: Text(
                                  t1,
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
