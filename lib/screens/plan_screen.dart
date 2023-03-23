import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  int IsSelected = 0;
  List subscriptionList = [
    {"title": "Free", "price": 5, "description": " All Info Details Free."},
    {"title": "Diary", "price": 10, "description": " All Info Details Free."},
    {"title": "Monthly", "price": 15, "description": " All Info Details Free."},
    {"title": "Yearly", "price": 20, "description": " All Info Details Free."},
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Our Plan",
            style: fontUtils.robotoRegular.copyWith(
                fontSize: height * 0.020, color: colorUtils.whiteColor),
          ),
          backgroundColor: colorUtils.appBarBgColor,
          centerTitle: true),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/jpg/bg.jpg"),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            ListView.builder(
              itemCount: 4,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      IsSelected = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: height * 0.02,
                        right: width * 0.05,
                        left: width * 0.05),
                    height: height * 0.11,
                    width: width,
                    padding: EdgeInsets.only(left: width * 0.05),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        color: IsSelected == index
                            ? colorUtils.blackColor
                            : colorUtils.whiteColor.withOpacity(0.4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: height * 0.01, bottom: height * 0.01),
                            child: Text(
                              subscriptionList[index]["title"],
                              style: fontUtils.robotoBold.copyWith(
                                fontSize: height * 0.02,
                                color: IsSelected == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )),
                        Text(
                          "Description : " +
                              subscriptionList[index]["description"],
                          style: fontUtils.robotoMedium.copyWith(
                            fontSize: height * 0.018,
                            color: IsSelected == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.01),
                          child: Text(
                            "\$ : " +
                                subscriptionList[index]["price"].toString(),
                            style: fontUtils.robotoMedium.copyWith(
                              fontSize: height * 0.02,
                              color: IsSelected == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.05, top: height * 0.03),
                  child: Text(
                    "payment Using...",
                    style: fontUtils.robotoBold.copyWith(
                        fontSize: height * 0.020, color: colorUtils.whiteColor),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId:
                                "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                            secretKey:
                                "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: const [
                              {
                                "amount": {
                                  "total": '10.12',
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": '10.12',
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": '10.12',
                                      "currency": "USD"
                                    }
                                  ],
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                            },
                            onError: (error) {
                              print("onError: $error");

                              Fluttertoast.showToast(
                                msg: "Ops! something went wrong",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                              Navigator.pop(context);
                            },
                            onCancel: (params) {
                              print('cancelled: $params');

                              Fluttertoast.showToast(
                                msg: "Ops! something went wrong",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                              Navigator.pop(context);
                            }),
                      ),
                    );
                  },
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        color: Colors.green.shade400),
                    margin: EdgeInsets.only(
                        left: width * 0.05, top: height * 0.015),
                    child: Text(
                      "Pay",
                      style: fontUtils.robotoBold.copyWith(
                          fontSize: height * 0.020,
                          color: colorUtils.whiteColor),
                    ),
                  ),
                ),
                /*Container(
                  height: height * 0.05,
                  width: width * 0.4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      color: Colors.green.shade400),
                  margin: EdgeInsets.only(
                      left: width * 0.05,
                      top: height * 0.015,
                      right: width * 0.05),
                  child: Text(
                    "Visa",
                    style: fontUtils.robotoBold.copyWith(
                        fontSize: height * 0.020, color: colorUtils.whiteColor),
                  ),
                ),*/
              ],
            )
          ],
        ),
      ),
    );
  }
}
