
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../Screens/pendingverificationpage.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   State<SplashScreen> createState() => InitState();
// }
//
// class InitState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   startTimer() async {
//     var duration = Duration(seconds: 3);
//     return Timer(duration, loginRoute);
//   }
//
//
//   loginRoute() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => LoginPage()));
//   }
//
//   Widget build(BuildContext context) {
//     return initWidget();
//   }
//
//   initWidget() {
//     return Scaffold(
//         body: Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Color(0xffF5591F),
//             gradient: LinearGradient(
//                 colors: [(Color(0xffF5591F)), Color(0xffF2861E)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter),
//           ),
//         ),
//         Center(
//           child: Container(
//               height: 140,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(20)),
//               child: Image.asset("assets/splash.png")),
//         )
//       ],
//     ));
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
  ];
  static const colorizeTextStyle = TextStyle(
  fontSize: 35.0,
  fontFamily: 'Horizon',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Color(colour),body:Center(child: SingleChildScrollView(
      child: Column(mainAxisSize:MainAxisSize.min,mainAxisAlignment:MainAxisAlignment.center,children: [Image.asset('assets/splash.png',),const SizedBox(height:5,),AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            textAlign:TextAlign.center,
            'SeeKos',
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
        ],
        isRepeatingAnimation: true,
        onTap: () {
        },
      )],),
    ),),);
  }
}
