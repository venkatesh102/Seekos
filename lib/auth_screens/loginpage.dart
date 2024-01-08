import 'package:seekos/Screens/botttomnavigationbatpage.dart';
import 'package:seekos/Screens/sellerregistrationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seekos/auth_screens/registrationpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Screens/pendingverificationpage.dart';
import '../main.dart';
import '../methods/authorizeuser.dart';
import '../methods/drawer.dart';
import 'forgotpassword.dart';
import 'identityverification.dart';

class LoginPage extends StatefulWidget {
  static const String id='loginpage';
  @override
  State<LoginPage> createState() => InitState();
}

class InitState extends State<LoginPage> {
  bool _obsurepassword = true;
  bool loading=false;
  @override
  var _formkey = GlobalKey<FormState>();
  late String _email, _password;
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
        body: loading?Center(child:CircularProgressIndicator()):SingleChildScrollView(
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Transform.scale(
                          scale: 1, child: Image.asset("assets/logo.png",color: Colors.white,))),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          ),
          Form(
              key: _formkey,
              child: Column(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                  child: TextFormField(
                    validator: (item) {
                      return item!.contains("@")
                          ? null
                          : 'Enter corrrect email';
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
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                  child: TextFormField(
                    validator: (item) {
                      return item!.length > 5
                          ? null
                          : 'Password must contain greater than 6 characters';
                    },
                    onChanged: (item) {
                      setState(() {
                        _password = item;
                      });
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obsurepassword,
                    cursorColor: Color(colour),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obsurepassword = !_obsurepassword;
                            });
                          },
                          child: _obsurepassword
                              ? Icon(
                                  Icons.visibility,
                                  color: Color(colour),
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Color(colour),
                                ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(colour),
                        ),
                        hintText: 'Enter Password',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context,
                        ForgetPassword.id);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 25),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Foget password?',
                      style: TextStyle(color: Color(colour)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    signin();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      'LOGIN',
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
              ])),
          Container(
            margin: EdgeInsets.only(left: 25, top: 10),
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                Text(
                  'Don\'t have account? ',
                  style: TextStyle(color: Colors.black),
                ),
                GestureDetector(
                    child: Container(
                      child: Text('Register now',
                          style: TextStyle(
                            color: Color(colour),
                          )),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context,RegistrationPage.id);
                    }),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void signin() {

    if (_formkey.currentState!.validate()) {
      setState((){
      loading=true;

    });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        currentUserDataMethod()
            .then((docs) {
          if (docs.docs[0].exists) {
            if (docs.docs[0].get('role') == 'admin') {
              Navigator.of(context).pushReplacementNamed(
                  BottomNavigationBarPage.id);
            } else {
              Navigator.of(context).pushReplacementNamed(LivePhotoAuth.id);
            }setState(() {
              loading=false;
            });
          }
        }).then((value){

        });

      }).catchError((onError) {
        setState((){
          loading=false;
        });
        Message(context, onError.toString());
      });
    }
  }
}
