import 'dart:async';

import 'package:seekos/methods/appconstants.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';

class VerifyEmailPage extends StatefulWidget {
  static const String id='verify-email';

  const VerifyEmailPage({super.key});
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}
class _VerifyEmailPageState extends State<VerifyEmailPage> {

  final FirebaseServices _firebaseServices=FirebaseServices();


  late Timer timer;
  bool isEmailVerified = false;
  @override
  void initState() {
    _firebaseServices.user!.sendEmailVerification() ;
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return LoginPage();

  }
  Future<void> checkEmailVerified() async
  {
    if (_firebaseServices.user!.emailVerified) {
      timer.cancel();
      // return PostUserdataToFirebase();
      Navigator.pushNamed(context, LoginPage.id);
    }
  }
}

