import 'package:audit_findings_app/Model/login_model.dart';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Views/audit_selection_panel.dart';
import 'package:audit_findings_app/Views/invoice_raised_but_not_received_panel.dart';
import 'package:audit_findings_app/Views/paymentMadeButNotReceivedPanel.dart';
import 'package:audit_findings_app/Views/productReceivedPanel.dart';
import 'package:audit_findings_app/Views/product_received_others_panel.dart';
import 'package:audit_findings_app/Views/shifted_to_sd_pannel.dart';
import 'package:audit_findings_app/Views/wrong_payment_posting_panel.dart';
import 'package:flutter/material.dart';
//import './question.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'  as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'Views/BusinessWithAciPanel.dart';
import 'Views/MORecoveryCommitmentPanel.dart';
import 'Views/OtherProblemsPanel.dart';
import 'Views/RSMRecoveryCommitmentPanel.dart';
import 'Views/StockWithFFPannel.dart';
import 'Views/UnderRateDiscountPanel.dart';
import 'Views/UnderRateDistcount.dart';
import 'Views/pending_incentive_panel.dart';
import 'Views/recovery_commited_panel.dart';
import 'Views/stock_with_ff_panel.dart';
import 'Views/view_edit_report.dart';
String token;

void main() {

  runApp(
      GetMaterialApp(
        getPages: [
          GetPage(name: '/', page: () =>MyApp()),
          GetPage(name: '/home', page: () => ViewEditReport()),
          GetPage(name: '/auditSelectionPanel', page: () => AuditSelectionPanel()),
          GetPage(name: "/wrong_payment", page: ()=>WrongPaymentPanel()),
          GetPage(name: "/invoice_raised_but_not_received", page: ()=>InvoiceRaisedButNotReceivedPanel()),
          GetPage(name: "/payment_made_not_deposited", page: ()=> PaymentMadeButNotReceivedPanel()),
          GetPage(name: "/shifted_to_sd", page: ()=> ShiftedToSDPanel()),
          GetPage(name: "/product_received", page: ()=> ProductReceivedPanel()),
          GetPage(name: "/product_received_others", page: ()=> ProductReceivedOthersPanel()),
          GetPage(name: "/ff_stock", page: ()=> StockWithFFnPanel2()),
          GetPage(name: "/underrate_product_sold", page: ()=> UnderRateDiscountPanel()),
          GetPage(name: "/pending_inventive_claim", page: ()=> PendingIncentivePanel()),
          GetPage(name: "/other-observations", page: ()=> OtherProblemsPanel()),
          GetPage(name: "/business_with_aci", page: ()=> BusinessWithAciPanel()),
          GetPage(name: "/recovery_commitment_customer", page: ()=> RecoveryCommittedPanel()),
          GetPage(name: "/recovery_commitment_mo", page: ()=> MORecoveryCommitmentPanel()),
          GetPage(name: "/recovery_commitment_rsm", page: ()=> RSMRecoveryCommitmentPanel()),
        ],
      home: MyApp()
  )
  );
}

class Controller extends GetxController {

}
class MyApp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<MyApp> {

  final controller = Get.put(Controller);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String userId = "5803";
  String password = "12345";
  RxBool statusResult = false.obs;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text('Authentication Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('User Id or Password is wrong.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertToken() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('loginToken', token);
  }

 Future<String> getToken() async{
    SharedPreferences prefs = await _prefs;
    String token =  prefs.getString('loginToken');
    print(prefs.getString('userId'));
    print(prefs.getString('password'));
    print(prefs.getString('SupervisorEmail'));
    print(prefs.getString('SupervisorUserName'));
    return token;
  }
  Future<void> getHttp() async {
    try {
      var response = await Dio().post('http://app.acibd.com/creditaudit/api/login', queryParameters: {
        'userId':userId,
        'password':password
      }

      );
      if(response.statusCode == 200){
        setState(() {
          statusResult = RxBool(true);
        });
      }

      if(response.data["token"] != null){
        // print(response.data["token"]);
        print(response.data);
        SharedPreferences prefs = await _prefs;


        if(response.data["user"]["Supervisor"] != null){
          print(response.data["user"]["Supervisor"]);
          setState(() {
            prefs.setString('SupervisorUserName',
                response.data["user"]["Supervisor"]["UserName"]);
            prefs.setString('SupervisorEmail',
                response.data["user"]["Supervisor"]["Email"]);
          });
        }
        setState(() {
          token = response.data["token"];
          statusResult = RxBool(true);
          prefs.setString('loginToken', token);
          prefs.setString('userId', userId);
          prefs.setString('password', password);
          getToken();


        });
      }
      else{
        setState(() {
          token = "";
        });
      }
    } catch (e) {
      setState(() {
        statusResult = RxBool(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;


    return SafeArea(
      child: Scaffold(

        body: Container(
          height: height,
          width: width,

          decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/login1.png"), fit: BoxFit.fill),

              ),
          child: Padding(
            padding: EdgeInsets.only(top: 50, bottom: 50,left: 30, right: 30),
            child: SingleChildScrollView(

              child: Center(
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        SizedBox(
                          height: 70,
                        ),

                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/aci_group_logo.png"),
                        ),
                        SizedBox(
                          height:10,
                        ),
                         Padding(
                           padding: EdgeInsets.all(5),
                           child: Text('INSTANT AUDIT REPORTING',
                             style: TextStyle(color: Colors.black),
                           ),
                         ),
                        SizedBox(
                          height:30,
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 50,right: 50),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "User Id",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          onChanged: (value){
                            setState(() {
                              try {
                                this.userId = value;
                                // etc.
                              } on FormatException {
                                this.userId = "";
                              }
                              print(this.userId);
                            });
                          },

                        ),
                      ),
                        SizedBox(
                          height:30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 50,right: 50),
                          child: TextField(

                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              filled: true,
                              fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            onChanged: (value){
                              setState(() {
                                // this.password = int.parse(value) ?? 0;
                                try {
                                  this.password = value;
                                  // etc.
                                } on FormatException {
                                  this.password = "";
                                }
                                print(this.password);
                              });
                            },

                          ),
                        ),
                        SizedBox(
                          height:30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Forgot password?'),
                            SizedBox(
                              height:10,
                            ),
                            RaisedButton(child: Text('Click here'),
                              onPressed: () async {
                              dynamic dataToken = await this.getToken();
                                print(dataToken);
                              //   if(dataToken != null && statusResult == true){
                              //     Get.to(ViewEditReport());
                              //   }
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height:30,
                        ),
                        ButtonTheme(
                          minWidth: width-151.4,

                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.green[500])
                            ),
                            textColor: Colors.white,
                            color: Colors.green[500],
                            onPressed: () async {
                              // print(await http.read('https://flutter.dev/'));
                              await getHttp();

                              // insertToken();
                              String dataToken = await this.getToken();
                              // print(dataToken);
                              setState(() {

                                new Timer(const Duration(milliseconds: 400), ()
                                {
                                  print(statusResult);
                                  if (statusResult == RxBool(true)) {
                                    print("ok");
                                    Get.toNamed("/home",);
                                  }
                                  else{
                                    _showMyDialog();
                                  }
                                });

                              });

                              // Get.to(ViewEditReport());


                            },
                            child: const Text('LOGIN', style: TextStyle(fontSize: 20,)),
                          ),
                        )

                      ]
                    ),
              ),

            ),
          ),
        ),
      ),
    );
  }
}

// Future<LoginResponseModel> getToken() async{
//   final url = "http://116.68.205.74/creditaudit/api/login?userId=5803&password=12345";
//   final response = await http.post();
//   if(response.statusCode == 200){
//     final jsonToken = jsonDecode(response.body);
//     print(jsonToken);
//     return LoginResponseModel.fromjson(jsonToken);
//   }
//   else{
//     throw Exception();
//   }
//
//
// }