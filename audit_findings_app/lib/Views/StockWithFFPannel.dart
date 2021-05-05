import 'dart:io';

import 'package:audit_findings_app/Model/wrong_payment_model.dart';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/TransactionListWidgets/InvoiceRaisedButNotReceivedTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/PaymentMadeNotDepositedTransactionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/ShiftedToSDTransactionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/StockWithFFTransactionList.dart';
import 'package:audit_findings_app/TransitionWdgets/InvoiceRaisedButNotReceivedTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/PaymentMadeNotDepositedTransaction.dart';
import 'package:audit_findings_app/TransitionWdgets/ShiftedToSDTransaction.dart';
import 'package:audit_findings_app/TransitionWdgets/StockWithFFTransision.dart';
import 'package:audit_findings_app/Views/view_edit_report.dart';
import 'package:audit_findings_app/Views/wrong_payment_transitions.dart';
import 'package:audit_findings_app/Views/wrong_transaction_list.dart';
import 'package:dio/dio.dart' as doi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class StockWithFFnPanel2 extends StatefulWidget {


  @override
  _StockWithFFnPanel2State createState() => _StockWithFFnPanel2State();
}

class _StockWithFFnPanel2State extends State<StockWithFFnPanel2> {
  Function deleteTX;
  final List<StockWithFF> _userTransactions = [];
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

  void _addNewTransaction(String invoice, int quantity, double amount, String ffName, String noOfWareHouse, String address,File image, DateTime date) {

    var newTX = StockWithFF(
      id: DateTime.now().toString(),
      invoice: invoice,
      quantity: quantity.toString(),
      amount: amount,
      ffName: ffName,
      noOfWareHouse: noOfWareHouse,
      address: address,
      date: date,
      image: image

    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.stockWithFFList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {
    if(counter >= i){
      Get.back();
      return;
    }

    print('Shifted to SD');




    try {
      Map<String, dynamic> parameters= {
        "Invoice": _userTransactions[counter].invoice,
        "Date" : _userTransactions[counter].date,
        "Quantity" : _userTransactions[counter].quantity.toString(),
        "Amount" : _userTransactions[counter].amount.toString(),
        "FFName" : _userTransactions[counter].ffName,
        "NoOfWarehouse" : _userTransactions[counter].noOfWareHouse,
        "Address": _userTransactions[counter].address,
        "CustomerInfoID": idOfAuditSelection,
      };
      doi.FormData formData = doi.FormData.fromMap({
        "Image": await doi.MultipartFile.fromFile(_userTransactions[counter].image.path, filename: "${DateTime.now().toString()}_ff_stock"),
      });
      var response = await doi.Dio().post(
          'http://116.68.205.74/creditaudit/api/ff_stock',queryParameters: parameters, data: formData);
      counter++;
      print(response.data);
      getHttp();

      setState(() {
      });

    }
    catch (e){
      print(e);
    }


  }

  void deleteTransaction(String id) {
    setState(() {
      AuditData.Owninstance.stockWithFFList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: StockWithFFTransision(_addNewTransaction),
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
          'Stock with FF',
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
                    child: StockWithFFTransactionList(

                      AuditData.Owninstance.stockWithFFList,
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
