import 'dart:io';

import 'package:audit_findings_app/Model/wrong_payment_model.dart';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Views/view_edit_report.dart';
import 'package:audit_findings_app/Views/wrong_payment_transitions.dart';
import 'package:audit_findings_app/Views/wrong_transaction_list.dart';
import 'package:dio/dio.dart' as doi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WrongPaymentPanel extends StatefulWidget {


  @override
  _WrongPaymentPanelState createState() => _WrongPaymentPanelState();
}

class _WrongPaymentPanelState extends State<WrongPaymentPanel> {
  Function deleteTX;
  final List<WrongPaymentData> _userTransactions = [];
  //
  // ];
  int i = 0;
  int counter = 0;
  String idOfAuditSelection;


  Future<String> getAuditSelectionId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('idOfAuditSelection');
    return data;
  }

  void _addNewTransaction(
      DateTime chosenDate, String code,String txTitle, double txAmount,File _image ) {
    // String id;
    // String customerInfoId;
    // DateTime date;
    // double amount;
    // String code;
    // String tMR;
    final newTX = WrongPaymentData(
        tMR: txTitle,
        amount: txAmount,
        date: chosenDate,
        code: code,
        id: DateTime.now().toString(),
        customerInfoId: idOfAuditSelection,
        image: _image,
    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.wrongPaymentDataList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {

    print('Test ');
    if(counter >= i){
      Get.back();
      return;
    }

    try {
       Map<String, dynamic> parameters= {
         "CustomerInfoID": idOfAuditSelection,
         "Date": _userTransactions[counter].date,
         "Amount": _userTransactions[counter].amount,
         "Code": _userTransactions[counter].code,
         "TMR": _userTransactions[counter].tMR
       };
       doi.FormData formData = doi.FormData.fromMap({
         "Image": await doi.MultipartFile.fromFile(_userTransactions[counter].image.path, filename: "${DateTime.now().toString()}_wrong_payment_file"),
       });
      var response = await doi.Dio().post(
          'http://116.68.205.74/creditaudit/api/wrong_payment_posting',queryParameters: parameters,data: formData);
      counter++;
      print(response.data);
      getHttp();

      setState(() {
      });

    }
    catch (e){

    }


  }

  void deleteTransaction(String id) {
    setState(() {
      AuditData.Owninstance.wrongPaymentDataList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: WrongPaymentTransition(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }
  void getRequiredData() async{
    idOfAuditSelection = await getAuditSelectionId();
  }
  @override
  void initState() {
    super.initState();
    getRequiredData();
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    final appbar = AppBar(
      title: Center(
        child: Text(
          'Wrong Payment',
        ),
      ),
      backgroundColor: Colors.green[500],
      leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () {
            Get.back();
          }
      ) ,
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),

      ],
    );
    return MaterialApp(

      home: SafeArea(

        child: Scaffold(
         appBar: appbar ,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Container(
                    height: height * 0.8,
                    child: WrongTransactionList(
                      AuditData.Owninstance.wrongPaymentDataList,
                      deleteTransaction,
                    ),
                  ),
                  RaisedButton(

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green[500])
                    ),
                    textColor: Colors.white,
                    color: Colors.green[500],
                    onPressed: ()  async{
                      // print(await http.read('https://flutter.dev/'));
                      await getHttp();


                    },
                    child: const Text('SUBMIT', style: TextStyle(fontSize: 20,)),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(

              backgroundColor: Colors.green[500],

              child: Icon(Icons.add),
              // onPressed: () => getIdForCustomerInfoId(),
              onPressed: () => _startAddNewTransaction(context),
            ),
          ),
        ),
      ),
    );
  }
}
