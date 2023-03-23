import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/navigation_screen.dart';
import '../services/auth_services.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isTap = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
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
              //=== Title of the App
              // Container(
              //   margin: EdgeInsets.only(top: height * 0.25),
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

              //=== Login title
              Container(
                margin: EdgeInsets.only(top: height * 0.04, left: width * 0.1),
                child: Text(
                  "SignUp",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.04,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.1, top: height * 0.01),
                height: height * 0.006,
                width: width * 0.15,
                decoration: BoxDecoration(
                    color: colorUtils.lightDarkBlueColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(5)),
              ),

              //=== User name textField
              Container(
                margin: EdgeInsets.only(
                    left: width * 0.1, right: width * 0.1, top: height * 0.015),
                child: TextField(
                    obscureText: false,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: colorUtils.lightDarkBlueColor.withOpacity(0.7),
                    controller: userNameController,
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
                            color:
                                colorUtils.lightDarkBlueColor.withOpacity(0.7)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                colorUtils.lightDarkBlueColor.withOpacity(0.7)),
                      ),
                      // add padding to adjust text
                      isDense: true,
                      hintText: "Enter user name",
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),

                      prefixIcon: Padding(
                        padding: EdgeInsets.only(top: 0),
                        // add padding to adjust icon
                        child: Icon(
                          Icons.people_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ),

              //=== Email textField
              Container(
                margin: EdgeInsets.only(
                    left: width * 0.1, right: width * 0.1, top: height * 0.015),
                child: TextField(
                    obscureText: false,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: emailController,
                    cursorColor: colorUtils.lightDarkBlueColor.withOpacity(0.7),
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
                            color:
                                colorUtils.lightDarkBlueColor.withOpacity(0.7)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                colorUtils.lightDarkBlueColor.withOpacity(0.7)),
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
                    left: width * 0.1, right: width * 0.1, top: height * 0.01),
                child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: passwordController,
                    cursorColor: colorUtils.lightDarkBlueColor.withOpacity(0.7),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                colorUtils.lightDarkBlueColor.withOpacity(0.7)),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                colorUtils.lightDarkBlueColor.withOpacity(0.7)),
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

              //=== SignUp Button
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isTap = true;
                  });
                  var signUpAuth = await AuthenticationHelper().signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  log(signUpAuth.toString() + "789");
                  /* if (signUpAuth is String) {
                      setState(() {
                        isTap=true;
                      });
                      print("we have error");is
                    } else */
                  if (signUpAuth == "unknown" ||
                      signUpAuth == "email-already-in-use" ||
                      signUpAuth == "invalid-email" ||
                      signUpAuth == "weak-password") {
                    Fluttertoast.showToast(
                      msg: signUpAuth.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                    );
                    setState(() {
                      isTap = false;
                    });
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationScreen(),
                        ),
                        (route) => false);
                    setState(() {
                      isTap = false;
                    });
                  }
                },
                child: isTap == false
                    ? Container(
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
                        child: Text(
                          "SIGNUP NOW",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: height * 0.06),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(height: height*0.045,width: height*0.045,padding: EdgeInsets.all(width*0.02),child: CircularProgressIndicator(strokeWidth: 2.0,color: Colors.white,)),
                            ),
                          ],
                        ),
                      ),
              ),

              //=====
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                  ;
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: width * 0.1, top: height * 0.01),
                  child: Text(
                    "Have an Account?",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
