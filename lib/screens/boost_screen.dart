import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp_32/screens/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';

class BoostScreen extends StatefulWidget {
  LatLng point;

  BoostScreen(this.point, {Key? key}) : super(key: key);

  @override
  State<BoostScreen> createState() => _BoostScreenState();
}

class _BoostScreenState extends State<BoostScreen> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  TextEditingController nameController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController _travelTypeController = TextEditingController();

  List travelType = ['Road', 'Ride', 'Bikeway', 'Dock', 'Other'];
  TextEditingController noOfMeterController = TextEditingController();
  var price;
  var place;
  bool isLoading = false;
  bool isTap = false;
  File? boostImage;
  String? boostImageNetworkImage;

  ///==== Price get from firebase =====
  getPriceMeter() async {
    await FirebaseFirestore.instance.collection("Price").get().then((value) {
      value.docs.forEach((element) {
        price = element.data()["price"];
        log(price.toString());
        //totalAmount=(price * noOfMeterController.text);
        // getAmount();
      });
    });
  }

  ///====== getAMount ====
  int totalAmount = 0;

  getAmount() {
    totalAmount =
        int.parse(price.toString()) * int.parse(noOfMeterController.text);
    setState(() {});
    log(totalAmount.toString());
  }

  ///===== setBoost data =====
  setBoost() async {
    setState(() {
      isLoading = true;
    });

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
                "description": "The payment transaction description.",
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
              await FirebaseFirestore.instance
                  .collection("Boost")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({
                "userId": FirebaseAuth.instance.currentUser!.uid,
                "name": nameController.text,
                "zipCode": zipCodeController.text,
                "street": streetController.text,
                "city": cityController.text,
                "country": countryController.text,
                "noOfMeter": noOfMeterController.text,
                "typeOfPlace": place.toString(),
                "totalAmount": totalAmount.toString(),
                "IBAN": ibanController.text,
                "travelType": _travelTypeController.text,
                "date": DateTime.now(),
                "lat": widget.point.latitude.toString(),
                "long": widget.point.longitude.toString()
              }, SetOptions(merge: true)).catchError((onError) {
                Fluttertoast.showToast(
                  msg: onError.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              });
              setState(() {
                isLoading = false;
              });
              Fluttertoast.showToast(
                msg: "Thank you for boost request",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
              );
              Navigator.pop(context);
            },
            onError: (error) {
              print("onError: $error");
              setState(() {
                isLoading = false;
              });
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
              setState(() {
                isLoading = false;
              });
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
  }

  @override
  void initState() {
    getPriceMeter();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51LSHE5LWjPzEwLzKJ0kNGnFrtenT4TtMTwBrlN5SWZI9L5A2jV3XzHkNLFZB8CzaJjaNF78nqU6xX39L6h0BhG4D00xBjADDOd",
        merchantId: "acct_1LSHE5LWjPzEwLzK",
        androidPayMode: 'test'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Boost screen",
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  getProfile();
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      right: width * 0.04,
                      left: width * 0.04,
                      top: height * 0.02),
                  height: height * 0.2,
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white)),
                  child: boostImageNetworkImage == null ||
                          boostImageNetworkImage == "null"
                      ? Icon(Icons.add)
                      : Image.network(boostImageNetworkImage!),
                ),
              ),
              customTextFormFiled(
                  hintText: "Name", lable: "Name", controller: nameController),
              customTextFormFiled(
                  hintText: "Street",
                  lable: "Street",
                  controller: streetController),
              customTextFormFiled(
                  hintText: "Zip Code",
                  lable: "Zip Code",
                  controller: zipCodeController),
              customTextFormFiled(
                  hintText: "City", lable: "City", controller: cityController),
              customTextFormFiled(
                  hintText: "Country",
                  lable: "Country",
                  controller: countryController),
              customTextFormFiled(
                  hintText: "IBAN", lable: "IBAN", controller: ibanController),
              dropDownMenu(),
              isTap
                  ? Container(
                      height: height * 0.15,
                      child: ListView.builder(
                        itemCount: travelType.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _travelTypeController.text = travelType[index];
                              isTap = !isTap;
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  bottom: height * 0.006,
                                  right: width * 0.04,
                                  left: width * 0.04),
                              padding: EdgeInsets.only(
                                  top: height * 0.006,
                                  bottom: height * 0.006,
                                  right: width * 0.04,
                                  left: width * 0.04),
                              color: Colors.white,
                              child: Text(travelType[index])),
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
              SizedBox(
                height: height * 0.006,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: height * 0.01,
                    left: width * 0.05,
                    right: width * 0.05),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ThemeData().colorScheme.copyWith(
                          primary: Colors.black,
                        ),
                  ),
                  child: TextFormField(
                    controller: noOfMeterController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: height * 0.022),
                    onChanged: (val) {
                      if (noOfMeterController.text.length != 0) {
                        getAmount();
                      } else {
                        setState(() {
                          totalAmount = 0;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      /*  suffixIcon: GestureDetector(5
                        onTap: () {
                          getAmount();
                        },
                        child: Container(
                            width: width * 0.1,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(width * 0.02)),
                            alignment: Alignment.center,
                            child: Text(
                              "CAL",
                              style: TextStyle(
                                  fontSize: height * 0.018,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),*/
                      hintText: "No Of Meter",
                      labelText: "No Of Meter",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.022,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                  margin: EdgeInsets.only(top: height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Total Payment Amount = ",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontSize: height * 0.018)),
                      Text(totalAmount.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.022)),
                    ],
                  )),
              //customTextFormFiled(hintText:"No Of Meter",lable: "No Of Meter",controller:noOfMeterController),
              ListTile(
                title: const Text('Private place'),
                leading: Radio(
                  value: "Private place",
                  activeColor: Colors.white,
                  groupValue: place,
                  onChanged: (value) {
                    setState(() {
                      place = value;
                      log(value.toString());
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Public Place'),
                leading: Radio(
                  value: "Public Place",
                  activeColor: Colors.white,
                  groupValue: place,
                  onChanged: (value) {
                    setState(() {
                      place = value;
                      log(value.toString());
                    });
                  },
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isLoading == false) {
                        setBoost();
                      }
                    },
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.5,
                      margin: EdgeInsets.only(
                          top: height * 0.03, bottom: height * 0.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.02),
                          color: colorUtils.appBarBgColor.withOpacity(0.8)),
                      alignment: Alignment.center,
                      child: isLoading
                          ? Center(
                              child: Container(
                                  height: height * 0.045,
                                  width: height * 0.045,
                                  padding: EdgeInsets.all(width * 0.02),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white,
                                  )),
                            )
                          : Text("Save",
                              style: TextStyle(
                                  fontSize: height * 0.020,
                                  color: colorUtils.whiteColor,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isLoading == false) {
                        setStripeBoost();
                      }
                    },
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.5,
                      margin: EdgeInsets.only(
                          top: height * 0.03, bottom: height * 0.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.02),
                          color: colorUtils.appBarBgColor.withOpacity(0.8)),
                      alignment: Alignment.center,
                      child: isLoading
                          ? Center(
                              child: Container(
                                  height: height * 0.045,
                                  width: height * 0.045,
                                  padding: EdgeInsets.all(width * 0.02),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white,
                                  )),
                            )
                          : Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: height * 0.020,
                                  color: colorUtils.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }

  customTextFormFiled(
      {String? hintText, String? lable, TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.only(
          top: height * 0.01, left: width * 0.05, right: width * 0.05),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Colors.black,
              ),
        ),
        child: TextFormField(
          controller: controller,
          style: TextStyle(fontSize: height * 0.022),
          decoration: InputDecoration(

              // icon: Icon(Icons.person),
              hintText: hintText,
              labelText: lable,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: height * 0.022,
              )),
        ),
      ),
    );
  }

  dropDownMenu() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTap = !isTap;
        });
      },
      child: Container(
        margin: EdgeInsets.only(
            top: height * 0.01, left: width * 0.05, right: width * 0.05),
        child: TextFormField(
          enabled: false,
          controller: _travelTypeController,
          style: TextStyle(fontSize: height * 0.022),
          decoration: InputDecoration(
              labelText: "Type of Infrastructure",
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: height * 0.022,
              )),
        ),
      ),
    );
  }

  getProfile() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    boostImage = File(image!.path);
    setState(() {});
    // userProfile = File(image.path);
    final storageRef = FirebaseStorage.instance.ref();
    await storageRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .putFile(boostImage!)
        .then((storedImage) async {
      boostImageNetworkImage = await storedImage.ref.getDownloadURL();
      setState(() {});
    });
  }

  void setStripeBoost() async {
 /*   Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(),
        ));*/
  }
}
