import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp_32/auth/signup_screen.dart';
import 'package:esp_32/screens/navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../admin/admin_dashboard.dart';
import '../services/auth_services.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isTap = false;

  ///===== Payments Collection Firebase add ========
  setPaymentsFirebaseValue() {
    FirebaseFirestore.instance.collection("Payments").doc().set({
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "name": "",
      "zipCode": "",
      "street": "",
      "city": "",
      "noOfMeter": "",
      "amount": ""
    }, SetOptions(merge: true));
  }

  ///======= Price collection firebase add =====
  setPriceFirebaseValue() {
    FirebaseFirestore.instance
        .collection("Price")
        .doc()
        .set({"price": ""}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBody: false,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/jpg/bg.jpg"),
                colorFilter: new ColorFilter.mode(
                    Colors.black87.withOpacity(0.02), BlendMode.colorBurn),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //=== app logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: height * 0.15,
                        width: height * 0.15,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: height * 0.1, bottom: height * 0.03),
                        padding: EdgeInsets.all(width * 0.025),
                        child: Image(
                          image: AssetImage("assets/images/png/logo tr.png"),
                          fit: BoxFit.fill,
                        )),
                  ],
                ),

                //=== Title of the App
                // Container(
                //   child: Row(
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(left: width * 0.12, right: 10),
                //         height: 8,
                //         width: 40,
                //         decoration: BoxDecoration(
                //             color:
                //                 colorUtils.lightDarkBlueColor.withOpacity(0.7),
                //             borderRadius: BorderRadius.circular(width * 0.03)),
                //       ),
                //       Text(
                //         "ESP 32",
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontSize: height * 0.026,
                //             fontWeight: FontWeight.w600),
                //       )
                //     ],
                //   ),
                // ),

                //=== Login title
                Container(
                  margin:
                      EdgeInsets.only(top: height * 0.04, left: width * 0.1),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.04,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.1, top: height * 0.01),
                  height: height * 0.006,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                      color: colorUtils.lightDarkBlueColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5)),
                ),

                //=== Email textField
                Container(
                  margin: EdgeInsets.only(
                      left: width * 0.1,
                      right: width * 0.1,
                      top: height * 0.015),
                  child: TextField(
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: emailController,
                      cursorColor:
                          colorUtils.lightDarkBlueColor.withOpacity(0.7),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: colorUtils.lightDarkBlueColor
                                  .withOpacity(0.7)),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: colorUtils.lightDarkBlueColor
                                  .withOpacity(0.7)),
                        ),
                        // add padding to adjust text
                        isDense: true,
                        hintText: "Email",
                        hintStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),

                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 0),
                          // add padding to adjust icon
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
                //=== Password textFiled
                Container(
                  margin: EdgeInsets.only(
                      left: width * 0.1,
                      right: width * 0.1,
                      top: height * 0.01),
                  child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: passwordController,
                      cursorColor:
                          colorUtils.lightDarkBlueColor.withOpacity(0.7),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: colorUtils.lightDarkBlueColor
                                  .withOpacity(0.7)),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: colorUtils.lightDarkBlueColor
                                  .withOpacity(0.7)),
                        ),
                        // add padding to adjust text
                        isDense: true,
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),

                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 0),
                          // add padding to adjust icon
                          child: Icon(
                            Icons.lock,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),

                //=== Login Button
                GestureDetector(
                    onTap: () async {
                      if (isTap == false) {
                        setState(() {
                          isTap = true;
                        });
                        var signInAuth = await AuthenticationHelper().signIn(
                            email: emailController.text,
                            password: passwordController.text);
                        log(signInAuth.toString());
                        if (signInAuth is String) {
                          print("we have error");
                          Fluttertoast.showToast(
                            msg: signInAuth.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                          setState(() {
                            isTap = false;
                          });
                        } else {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "emailId": emailController.text,
                          });
                          setPaymentsFirebaseValue();
                          setPriceFirebaseValue();
                          if (emailController.text == "test123@gmail.com") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => adminDashboard(),
                                ));
                          } else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationScreen(),
                                ),
                                (route) => false);
                          }
                        }
                      }
                      setState(() {
                        isTap = false;
                      });
                    },
                    child: Container(
                        margin: EdgeInsets.only(
                            left: width * 0.1,
                            right: width * 0.1,
                            top: height * 0.05),
                        height: 50,
                        width: 400,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.02),
                          border: Border.all(
                              color: colorUtils.lightDarkBlueColor
                                  .withOpacity(0.7),
                              width: width * 0.008),
                        ),
                        child: isTap == false
                            ? Text(
                                "LOGIN NOW",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            : Center(
                                child: Container(
                                    height: height * 0.045,
                                    width: height * 0.045,
                                    padding: EdgeInsets.all(width * 0.02),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Colors.white,
                                    )),
                              ))),

                //=== SigUp and ForgetPassword
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ));
                        },
                        child: Text(
                          "Create a new Account",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        "Forget password?",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),

                /*   Container(
                  margin: EdgeInsets.only(
                      top: height * 0.05, bottom: height * 0.01),
                  alignment: Alignment.center,
                  child: Text(
                    "Or Login with",
                    style: TextStyle(
                        fontSize: height * 0.020,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),

                //===== google and facebook sigin ====
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: height * 0.07,
                        width: height * 0.07,
                        padding: EdgeInsets.all(width * 0.03),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorUtils.whiteColor.withOpacity(0.3),
                        ),
                        child: Image(
                          image: AssetImage("assets/images/png/google.png"),
                          fit: BoxFit.fill,
                        )),
                    Container(
                        height: height * 0.07,
                        width: height * 0.07,
                        margin: EdgeInsets.only(left: width * 00.05),
                        padding: EdgeInsets.all(width * 0.025),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorUtils.whiteColor.withOpacity(0.3),
                        ),
                        child: Image(
                          image: AssetImage("assets/images/png/facebook.png"),
                          fit: BoxFit.fill,
                        )),
                  ],
                ),*/
              ],
            ),
          ),
        ));
  }
}
