import 'package:esp_32/auth/login_screen.dart';
import 'package:flutter/material.dart';

import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';
import '../screens/navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/jpg/bg.jpg"),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: height * 0.08),
              height: height * 0.4,
              width: width,
              // color: Colors.white30,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.06, bottom: height * 0.01),
                    child: Text(
                      "",
                      style: fontUtils.robotoRegular.copyWith(
                          fontSize: height * 0.020,
                          color: colorUtils.whiteColor),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.0),
                    child: Text(
                      "INTRO",
                      style: fontUtils.robotoRegular.copyWith(
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.w400,
                          color: colorUtils.whiteColor),
                    ),
                  ),
                  Divider(
                    color: Colors.red,
                    thickness: height * 0.0015,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.02,
                        left: width * 0.2,
                        right: width * 0.2),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "SAFETY",
                          textAlign: TextAlign.justify,
                          style: fontUtils.robotoRegular.copyWith(
                              fontSize: height * 0.044,
                              fontWeight: FontWeight.w600,
                              color: colorUtils.whiteColor),
                        ),
                        Text(
                          "WARNING",
                          textAlign: TextAlign.justify,
                          style: fontUtils.robotoRegular.copyWith(
                              fontSize: height * 0.044,
                              fontWeight: FontWeight.w600,
                              color: colorUtils.whiteColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.03,
                        left: width * 0.15,
                        right: width * 0.15),
                    // alignment: Alignment.center,
                    child: Text(
                      "DO NOT MANAGE OR CONFIGURE THIS APP WHILE DRIVING.",
                      textAlign: TextAlign.center,
                      style: fontUtils.robotoRegular.copyWith(
                          letterSpacing: 2.0,
                          fontSize: height * 0.020,
                          fontWeight: FontWeight.w500,
                          color: colorUtils.whiteColor),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              child: Container(
                height: height * 0.06,
                width: width * 0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.02),
                  color: Colors.white30,
                ),
                child: Text(
                  "Start Navigation",
                  style: fontUtils.robotoRegular.copyWith(
                      fontSize: height * 0.026,
                      fontWeight: FontWeight.w500,
                      color: colorUtils.blackColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
