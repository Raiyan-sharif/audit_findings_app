import 'dart:io';

import 'package:audit_findings_app/Model/wrong_payment_model.dart';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/TransactionListWidgets/InvoiceRaisedButNotReceivedTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/PaymentMadeNotDepositedTransactionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/ShiftedToSDTransactionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/StockWithFFTransactionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/UnderRateDiscountTransitionList.dart';
import 'package:audit_findings_app/TransitionWdgets/InvoiceRaisedButNotReceivedTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/PaymentMadeNotDepositedTransaction.dart';
import 'package:audit_findings_app/TransitionWdgets/ShiftedToSDTransaction.dart';
import 'package:audit_findings_app/TransitionWdgets/StockWithFFTransision.dart';
import 'package:audit_findings_app/TransitionWdgets/UnderRateDiscountTransition.dart';
import 'package:audit_findings_app/Views/view_edit_report.dart';
import 'package:audit_findings_app/Views/wrong_payment_transitions.dart';
import 'package:audit_findings_app/Views/wrong_transaction_list.dart';
import 'package:dio/dio.dart' as doi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UnderRateDiscountPanel extends StatefulWidget {


  @override
  _UnderRateDiscountPanelState createState() => _UnderRateDiscountPanelState();
}

class _UnderRateDiscountPanelState extends State<UnderRateDiscountPanel> {
  Function deleteTX;
  final List<UnderrateProductSold> _userTransactions = [];
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
  String remarks,
  double amount,
  String productName,
  String quality,
  String rate,
  String dP,
  String gAP,
  File image
      ) {
//this.id,this.customerInfoId,this.remarks,this.amount,this.productCode,this.productName,this.quality,this.rate,this.dP,this.gAP,this.image
    var newTX = UnderrateProductSold(
        id: DateTime.now().toString(),
        customerInfoId: idOfAuditSelection,
        remarks: remarks,
        amount: amount,
        productName: productName,
        quality: quality,
        rate: rate,
        dP: dP,
        gAP: gAP,
        image: image

    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.underrateProductSoldList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {
    if(counter >= i){
      Get.back();
      return;
    }

    print('Under rated Product');


    /*
    "Quantity" : quantity.toString(),
        "Amount" : amountController.text,
        "CustomerInfoID": idOfAuditSelection,
        "Remarks": remarks,
        "ProductName": productName,
        "Rate": rate,
        "DP":dp,
        "GAP":gapController.text
     */

    try {
      Map<String, dynamic> parameters= {
        "Invoice": "under rated",
        "ProductName": _userTransactions[counter].productName,
        "Quantity" : _userTransactions[counter].quality.toString(),
        "Amount" : _userTransactions[counter].amount.toString(),
        "CustomerInfoID": idOfAuditSelection,
        "Remarks": _userTransactions[counter].remarks,
        "Rate": _userTransactions[counter].rate,
        "DP": _userTransactions[counter].dP,
        "GAP": _userTransactions[counter].gAP,
      };
      doi.FormData formData = doi.FormData.fromMap({
        "Image": await doi.MultipartFile.fromFile(_userTransactions[counter].image.path, filename: "${DateTime.now().toString()}_under_rated_product"),
      });
      var response = await doi.Dio().post(
          'http://116.68.205.74/creditaudit/api/underrate_product_sold',queryParameters: parameters, data: formData);
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
      AuditData.Owninstance.underrateProductSoldList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: UnderRateDiscountTransition(_addNewTransaction),
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
          'Under Rated Discount',
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
                    child: UnderRateDiscountTransitionList(

                      AuditData.Owninstance.underrateProductSoldList,
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
