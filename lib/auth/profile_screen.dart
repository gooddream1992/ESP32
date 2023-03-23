import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool _status = true;
  bool isLoading = false;
  final FocusNode myFocusNode = FocusNode();
  PickedFile? pickedImage;
  File? imageFile;
  File? profileImage;
  bool _load = false;
  String userProfile = "";
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  TextEditingController doorNumberController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController stateController = TextEditingController();



  @override
  void initState() {
    super.initState();
    getData();
    //buildGetData();
  }

  buildGetData() async {
    await FirebaseFirestore.instance
        .collection("LEDs")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        "lat":"2.000",
        "lang":'2.000',
        "isFaulty":true,
      }
    );
    //     .then((value) {
    //   log(value.data().toString());
    //   setState(() {
    //     nameController.text = value.data()!["name"] ?? "";
    //     emailController.text = value.data()!["emailId"] ?? "";
    //     doorNumberController.text = value.data()!["doorNumber"] ?? "";
    //     streetController.text = value.data()!["street"] ?? "";
    //     cityController.text = value.data()!["city"] ?? "";
    //     countryController.text = value.data()!["country"] ?? "";
    //     userProfile = value.data()!["profile"] ?? "";
    //     //addressController.text = value.data()!["address"] ?? "";
    //     mobileController.text = value.data()!["mobileNumber"] ?? "";
    //     ageController.text = value.data()!["age"] ?? "";
    //     genderController.text = value.data()!["gender"] ?? "";
    //     pinController.text = value.data()!["pinCode"] ?? "";
    //     stateController.text = value.data()!["state"] ?? "";
    //     brandController.text = value.data()!["brand"] ?? "";
    //     modelController.text = value.data()!["model"] ?? "";
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Profile",
              style: fontUtils.robotoRegular.copyWith(
                  fontSize: height * 0.020, color: colorUtils.whiteColor),
            ),
            backgroundColor: colorUtils.appBarBgColor,
            centerTitle: true),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/jpg/bg.jpg"),
              colorFilter: ColorFilter.mode(
                  Colors.black87.withOpacity(0.02), BlendMode.colorBurn),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: /*isLoading? CircularProgressIndicator():*/
                Column(
              children: [
                // Container(
                //   child: _load == true ?
                //   Container(
                //     height: 200,
                //     width: 200,
                //     decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: FileImage(imageFile),
                //         ),
                //         borderRadius: BorderRadius.circular(20)),
                //     padding: const EdgeInsets.all(15.0),
                //   ) :
                //   Padding(
                //     padding: const EdgeInsets.all(15.0),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(20.0),
                //       child: Image.file(
                //         defaultPic,
                //         height: 250.0,
                //         width: 300.0,
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     chooseImage(ImageSource.gallery);
                //   },
                //   child: Text('Upload Picture'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.red,
                //     elevation: 3,
                //     shape: new RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(50.0),
                //     ),
                //   ),
                // ),
                Container(
                  height: height * 0.18,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.02),
                        child: Stack(fit: StackFit.loose, children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  Container(
                              //     width: 140.0,
                              //     height: 140.0,
                              //     decoration:  BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       image:  DecorationImage(
                              //         image:  ExactAssetImage(
                              //             'assets/images/as.png'),
                              //         fit: BoxFit.cover,
                              //       ),
                              //     )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                top: height * 0.02,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        !_status ? getProfile() : Container();
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 50.0,
                                      child: userProfile != ""
                                          ? Container(
                                              width: height * 0.3,
                                              height: height * 0.3,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(userProfile),
                                                  fit: BoxFit.cover,
                                                ),
                                              ))
                                          : profileImage == null
                                              ? Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                )
                                              : Container(
                                                  width: height * 0.3,
                                                  height: height * 0.3,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                          profileImage!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * 0.05),
                            child: Text(
                              'Personal Information',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _status ? _getEditIcon() : Container(),
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Name',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        fontWeight: FontWeight.bold,
                                        color: colorUtils.whiteColor),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: nameController,
                                  style: fontUtils.robotoMedium
                                      .copyWith(color: colorUtils.blackColor),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: colorUtils.blackColor),
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
                                    hintText: "Enter Your Name",
                                    hintStyle: fontUtils.robotoMedium.copyWith(
                                        color: colorUtils.lightDarkBlueColor,
                                        fontSize: height * 0.016),
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Email ID',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: emailController,
                                  style: fontUtils.robotoMedium
                                      .copyWith(color: colorUtils.blackColor),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: colorUtils.blackColor),
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
                                    hintText: "Enter Your Email Id",
                                    hintStyle: fontUtils.robotoMedium.copyWith(
                                        color: colorUtils.lightDarkBlueColor,
                                        fontSize: height * 0.016),
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ],
                          )),

                      ///====== address =======
                      // customText("Address"),
                      // customTextFormField(addressController, "Enter Adress"),

                      ///===== Door number ,Street====
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Door Number',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Street',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: TextField(
                                            controller: doorNumberController,
                                            style: fontUtils.robotoMedium
                                                .copyWith(
                                                    color:
                                                        colorUtils.blackColor),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        colorUtils.blackColor),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              // add padding to adjust text
                                              isDense: true,
                                              hintText: "Door Number",
                                              hintStyle: fontUtils.robotoMedium
                                                  .copyWith(
                                                      color: colorUtils
                                                          .lightDarkBlueColor,
                                                      fontSize: height * 0.016),
                                            ),
                                            enabled: !_status,
                                            autofocus: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                flex: 2,
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        controller: streetController,
                                        style: fontUtils.robotoMedium.copyWith(
                                            color: colorUtils.blackColor),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils.blackColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          // add padding to adjust text
                                          isDense: true,
                                          hintText: "Enter Street",
                                          hintStyle: fontUtils.robotoMedium
                                              .copyWith(
                                                  color: colorUtils
                                                      .lightDarkBlueColor,
                                                  fontSize: height * 0.016),
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 2,
                              ),
                            ],
                          )),

                      ///===== City,state====
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'City ',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Country',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: TextField(
                                            controller: cityController,
                                            style: fontUtils.robotoMedium
                                                .copyWith(
                                                    color:
                                                        colorUtils.blackColor),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        colorUtils.blackColor),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              // add padding to adjust text
                                              isDense: true,
                                              hintText: "City",
                                              hintStyle: fontUtils.robotoMedium
                                                  .copyWith(
                                                      color: colorUtils
                                                          .lightDarkBlueColor,
                                                      fontSize: height * 0.016),
                                            ),
                                            enabled: !_status,
                                            autofocus: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                flex: 2,
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        controller: countryController,
                                        style: fontUtils.robotoMedium.copyWith(
                                            color: colorUtils.blackColor),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils.blackColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          // add padding to adjust text
                                          isDense: true,
                                          hintText: "Country",
                                          hintStyle: fontUtils.robotoMedium
                                              .copyWith(
                                                  color: colorUtils
                                                      .lightDarkBlueColor,
                                                  fontSize: height * 0.016),
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 2,
                              ),
                            ],
                          )),

                      ///===== pin code, Country====
                      // Padding(
                      //     padding: EdgeInsets.only(
                      //         left: 25.0, right: 25.0, top: 25.0),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.max,
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Expanded(
                      //           child: Container(
                      //             child: Text(
                      //               'Pin Code',
                      //               style: fontUtils.robotoMedium.copyWith(
                      //                   fontSize: height * 0.016,
                      //                   color: colorUtils.whiteColor),
                      //             ),
                      //           ),
                      //           flex: 2,
                      //         ),
                      //
                      //       ],
                      //     )),
                      // Padding(
                      //     padding: EdgeInsets.only(
                      //         left: 25.0, right: 25.0, top: 2.0),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.max,
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Flexible(
                      //           child: Padding(
                      //               padding: EdgeInsets.only(
                      //                   right: 25.0, top: 2.0),
                      //               child: Row(
                      //                 mainAxisSize: MainAxisSize.max,
                      //                 children: [
                      //                   Flexible(
                      //                     child: TextField(
                      //                       controller: pinController,
                      //                       style: fontUtils.robotoMedium
                      //                           .copyWith(
                      //                           color: colorUtils
                      //                               .blackColor),
                      //                       decoration: InputDecoration(
                      //                         contentPadding: EdgeInsets.only(
                      //                             top: 20, bottom: 20),
                      //                         enabledBorder:
                      //                         UnderlineInputBorder(
                      //                           borderSide: BorderSide(
                      //                               color: colorUtils
                      //                                   .blackColor),
                      //                         ),
                      //                         focusedBorder:
                      //                         UnderlineInputBorder(
                      //                           borderSide: BorderSide(
                      //                               color: colorUtils
                      //                                   .lightDarkBlueColor
                      //                                   .withOpacity(0.7)),
                      //                         ),
                      //                         border: UnderlineInputBorder(
                      //                           borderSide: BorderSide(
                      //                               color: colorUtils
                      //                                   .lightDarkBlueColor
                      //                                   .withOpacity(0.7)),
                      //                         ),
                      //                         // add padding to adjust text
                      //                         isDense: true,
                      //                         hintText: "Enter Pin Code",
                      //                         hintStyle: fontUtils
                      //                             .robotoMedium
                      //                             .copyWith(
                      //                             color: colorUtils
                      //                                 .lightDarkBlueColor,
                      //                             fontSize:
                      //                             height * 0.016),
                      //                       ),
                      //                       enabled: !_status,
                      //                       autofocus: !_status,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               )),
                      //           flex: 2,
                      //         ),
                      //
                      //
                      //       ],
                      //     )),

                      ///==== mobile number ====
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Mobile',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: mobileController,
                                  style: fontUtils.robotoMedium
                                      .copyWith(color: colorUtils.blackColor),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: colorUtils.blackColor),
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
                                    hintText: "Enter Your Mobile No",
                                    hintStyle: fontUtils.robotoMedium.copyWith(
                                        color: colorUtils.lightDarkBlueColor,
                                        fontSize: height * 0.016),
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ],
                          )),

                      ///====== age , gender ====
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Age',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Gender',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: TextField(
                                            controller: ageController,
                                            style: fontUtils.robotoMedium
                                                .copyWith(
                                                    color:
                                                        colorUtils.blackColor),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        colorUtils.blackColor),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              // add padding to adjust text
                                              isDense: true,
                                              hintText: "Enter Age",
                                              hintStyle: fontUtils.robotoMedium
                                                  .copyWith(
                                                      color: colorUtils
                                                          .lightDarkBlueColor,
                                                      fontSize: height * 0.016),
                                            ),
                                            enabled: !_status,
                                            autofocus: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                flex: 2,
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        controller: genderController,
                                        style: fontUtils.robotoMedium.copyWith(
                                            color: colorUtils.blackColor),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils.blackColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          // add padding to adjust text
                                          isDense: true,
                                          hintText: "Enter Gender",
                                          hintStyle: fontUtils.robotoMedium
                                              .copyWith(
                                                  color: colorUtils
                                                      .lightDarkBlueColor,
                                                  fontSize: height * 0.016),
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 2,
                              ),
                            ],
                          )),

                      ///===== brand , model====
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Brand',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'Model',
                                    style: fontUtils.robotoMedium.copyWith(
                                        fontSize: height * 0.016,
                                        color: colorUtils.whiteColor),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 25.0, top: 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          child: TextField(
                                            controller: brandController,
                                            style: fontUtils.robotoMedium
                                                .copyWith(
                                                    color:
                                                        colorUtils.blackColor),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        colorUtils.blackColor),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorUtils
                                                        .lightDarkBlueColor
                                                        .withOpacity(0.7)),
                                              ),
                                              // add padding to adjust text
                                              isDense: true,
                                              hintText: "Enter Brand",
                                              hintStyle: fontUtils.robotoMedium
                                                  .copyWith(
                                                      color: colorUtils
                                                          .lightDarkBlueColor,
                                                      fontSize: height * 0.016),
                                            ),
                                            enabled: !_status,
                                            autofocus: !_status,
                                          ),
                                        ),
                                      ],
                                    )),
                                flex: 2,
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        controller: modelController,
                                        style: fontUtils.robotoMedium.copyWith(
                                            color: colorUtils.blackColor),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils.blackColor),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: colorUtils
                                                    .lightDarkBlueColor
                                                    .withOpacity(0.7)),
                                          ),
                                          // add padding to adjust text
                                          isDense: true,
                                          hintText: "Enter Model",
                                          hintStyle: fontUtils.robotoMedium
                                              .copyWith(
                                                  color: colorUtils
                                                      .lightDarkBlueColor,
                                                  fontSize: height * 0.016),
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                      !_status ? _getActionButtons() : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.05,
          right: width * 0.05,
          top: height * 0.03,
          bottom: height * 0.02),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Save"),
                // textColor: Colors.white,
                // color: Colors.green,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set({
                    "name": nameController.text,
                    "emailId": emailController.text,
                    // "address": addressController.text,
                    "profile": userProfile,
                    "doorNumber": doorNumberController.text,
                    "street": streetController.text,
                    "city": cityController.text,
                    "country": countryController.text,
                    "mobileNumber": mobileController.text,
                    "age": ageController.text,
                    "gender": genderController.text,
                    "brand": brandController.text,
                    "model": modelController.text,
                    // "lat": "",
                    // "long": "",
                    //"isActive": true,
                    "lightSide":"",
                    "isSubscribe": "test",
                    "userVelocity": "test",
                    "userDistance": "test",
                    "closestUser": "test",
                  },SetOptions(merge: true));
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: Text("Cancel"),
                // textColor: Colors.white,
                // color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: Container(
        height: height * 0.035,
        alignment: Alignment.center,
        width: width * 0.2,
        margin: EdgeInsets.only(right: width * 0.05),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.02),
            color: Colors.red),
        child: Text(
          "Edit",
          style: TextStyle(
              color: Colors.white,
              fontSize: height * 0.018,
              fontWeight: FontWeight.w600),
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget customText(String title) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: fontUtils.robotoMedium.copyWith(
                      fontSize: height * 0.016, color: colorUtils.whiteColor),
                ),
              ],
            ),
          ],
        ));
  }

  Widget customTextFormField(TextEditingController controller, String hint) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              style:
                  fontUtils.robotoMedium.copyWith(color: colorUtils.blackColor),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorUtils.blackColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: colorUtils.lightDarkBlueColor.withOpacity(0.7)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: colorUtils.lightDarkBlueColor.withOpacity(0.7)),
                ),
                // add padding to adjust text
                isDense: true,
                hintText: hint,
                hintStyle: fontUtils.robotoMedium.copyWith(
                    color: colorUtils.lightDarkBlueColor,
                    fontSize: height * 0.016),
              ),
              enabled: !_status,
              autofocus: !_status,
            ),
          ),
        ],
      ),
    );
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      log(value.data().toString());
      setState(() {
        nameController.text = value.data()!["name"] ?? "";
        emailController.text = value.data()!["emailId"] ?? "";
        doorNumberController.text = value.data()!["doorNumber"] ?? "";
        streetController.text = value.data()!["street"] ?? "";
        cityController.text = value.data()!["city"] ?? "";
        countryController.text = value.data()!["country"] ?? "";
        userProfile = value.data()!["profile"] ?? "";
        //addressController.text = value.data()!["address"] ?? "";
        mobileController.text = value.data()!["mobileNumber"] ?? "";
        ageController.text = value.data()!["age"] ?? "";
        genderController.text = value.data()!["gender"] ?? "";
        pinController.text = value.data()!["pinCode"] ?? "";
        stateController.text = value.data()!["state"] ?? "";
        brandController.text = value.data()!["brand"] ?? "";
        modelController.text = value.data()!["model"] ?? "";
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  getProfile() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(image!.path);
    });
    // userProfile = File(image.path);
    final storageRef = FirebaseStorage.instance.ref();
    await storageRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .putFile(profileImage!)
        .then((storedImage) async {
      setState(() async {
        userProfile = await storedImage.ref.getDownloadURL();
      });
    });

  }
}
