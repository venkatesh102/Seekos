import 'package:seekos/Screens/pendingverificationpage.dart';
import 'package:seekos/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  // const FogetPassword({Key? key}) : super(key: key);
static const String id='forgetpassword';
  @override
  State<ForgetPassword> createState() => InitState();
}

class InitState extends State<ForgetPassword> {
  TextEditingController editingController = TextEditingController();
  @override
  late String _email;
  var _fogetformkey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return InitWidget();
  }

  Widget InitWidget() {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color(colour),
                gradient: LinearGradient(colors: [
                  Color(colour),
                  Color(0xff9ae9f7),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Transform.scale(
                            scale: 1, child: Image.asset("assets/splash.png"))),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 20,bottom: 20),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50.0,
                      color: Color(0xffEEEEEEE))
                ],
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200]),
            child: Form(
              key: _fogetformkey,
              child: TextFormField(
                controller: editingController,
                validator: (item) {
                  return item!.contains("@") ? null : 'Enter corrrect email';
                },
                onChanged: (item) {
                  setState(() {
                    _email = item.trim();
                  });
                },
                keyboardType: TextInputType.emailAddress,
                cursorColor: Color(colour),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(colour),
                    ),
                    hintText: 'Enter Email',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
          ),

          GestureDetector(
            onTap: () async {
              forgetpassword(context);
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.white),
              ),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [(Color(colour)), Color(0xff9ae9f7)]),
                  borderRadius: BorderRadius.circular(50),
                  color: Color(colour)),
            ),
          ),
        ],
      ),
    ),
    );
  }

  void forgetpassword(BuildContext context) async {
    if(_fogetformkey.currentState!.validate()){
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: editingController.text.toString()).then((user){
        Message(context,"A message send to your email so please follow rules to reset password");
        Navigator.pop(context);

      }).catchError((onError){
        Message(context,onError.toString());
      });
    }
  }
}
