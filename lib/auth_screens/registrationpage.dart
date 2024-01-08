import 'dart:async';
import 'package:seekos/Screens/homescreen.dart';
import 'package:seekos/methods/drawer.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../Screens/pendingverificationpage.dart';
import '../methods/postuserdata.dart';
TextEditingController email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _confirmpassword = TextEditingController();
TextEditingController location = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController phone_number = TextEditingController();
class RegistrationPage extends StatefulWidget {
  static const String id = 'registrationpage';
  @override
  State<RegistrationPage> createState() => InitState();
}

class InitState extends State<RegistrationPage> {
  CountryCode? countryCode;
  @override
  bool loading = false;
  var _formkey = GlobalKey<FormState>();
  final countrypicker = FlCountryCodePicker();
  bool _obsurepassword = true;
  bool _obscureconfirmpassword = true;

  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
        body: loading
            ? Center(child: CircularProgressIndicator(),)
            : SingleChildScrollView(
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
                    ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Transform.scale(
                                scale: 1, child: Image.asset(
                                "assets/splash.png"))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            alignment: Alignment.bottomRight,
                            margin:
                            EdgeInsets.only(right: 10, left: 20, bottom: 20),
                            child: Text(
                              "Register",
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
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
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
                        controller: name,
                        validator: (item) {
                          return item!.length > 0
                              ? null
                              : 'Name can\'t be empty';
                        },
                        onChanged: (item) {},
                        keyboardType: TextInputType.name,
                        cursorColor: Color(colour),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(colour),
                            ),
                            hintText: 'Enter Full Name*',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                        // autovalidateMode: on,
                        controller: email,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        validator: (item) {
                          if (item!.length == 0) {
                            return "Email can't be empty";
                          }
                          else {
                            return null;
                          }
                        },
                        onChanged: (item) {},
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Color(colour),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff9ae9f7),
                            ),
                            hintText: 'Enter Email*',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      padding: EdgeInsets.only(left: 0, right: 20),
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
                        controller: phone_number,
                        // initialValue: countryCode.toString(),
                        validator: (item) {
                          if (item?.length == 10 || item?.length == 0) {
                            return null;
                          } else {
                            return 'Enter correct phone number';
                          }
                        },
                        textInputAction: TextInputAction.done,
                        maxLines: 1,

                        keyboardType: TextInputType.phone,
                        cursorColor: Color(colour),
                        decoration: InputDecoration(
                            prefixIcon: Container(
                              padding: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    bottomLeft: Radius.circular(50)),
                                color: Colors.grey[400],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final code = await countrypicker
                                          .showPicker(
                                          context: context);
                                      setState(() {
                                        countryCode = code;
                                      });
                                    },
                                    child: Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          countryCode?.dialCode ?? "+91",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff)),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            hintText: 'Enter phone number',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                        controller: _password,
                        validator: (item) {
                          if (item!.isEmpty) {
                            return 'Password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (item) {},
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
                            hintText: 'Set Password*',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                          if (_confirmpassword.text == _password.text) {
                            return 'password did not match';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (item) {},
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureconfirmpassword,
                        cursorColor: Color(colour),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureconfirmpassword =
                                  !_obscureconfirmpassword;
                                });
                              },
                              child: _obscureconfirmpassword
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
                            hintText: 'Confirm Password* ',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                        controller: location,
                        validator: (item) {
                          return item!.length > 0
                              ? null
                              : 'Location can\'t be null';
                        },
                        onChanged: (item) {},
                        keyboardType: TextInputType.name,
                        cursorColor: Color(colour),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on_sharp,
                              color: Color(colour),
                            ),
                            hintText: 'Location*',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        signup();
                        // });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'REGISTER',
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

              Container(
                margin: EdgeInsets.only(right: 25, top: 10),
                alignment: Alignment.bottomLeft,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Already have account? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Text('Login',
                              style: TextStyle(
                                color: Color(colour),
                              )),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 50,
              )
              // Ch
            ],
          ),
        ));
  }

  Future<void> signup() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email.text, password: _password.text)
          .then((user) async {
        PostUserdataToFirebase(context).then((value) async {
          Navigator.pushNamedAndRemoveUntil(
              context,HomeScreen.id, (Route<dynamic> route) => false);
          setState(() {
            loading = false;
          });
        }).catchError((onError) {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(msg: onError.toString());
        });
      });
      // else {
      //   Fluttertoast.showToast(msg: 'A message send to your email');
      // }
    }
  }


}
