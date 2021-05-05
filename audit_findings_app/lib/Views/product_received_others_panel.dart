
import 'package:audit_findings_app/Model/wrong_payment_model.dart';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/TransactionListWidgets/InvoiceRaisedButNotReceivedTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/PaymentMadeNotDepositedTransactionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/ProductReceivedOthersTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/ProductReceivedTransactionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/ShiftedToSDTransactionList.dart';
import 'package:audit_findings_app/TransitionWdgets/InvoiceRaisedButNotReceivedTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/PaymentMadeNotDepositedTransaction.dart';
import 'package:audit_findings_app/TransitionWdgets/ProductReceivedOthersTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/ProductReceivedTransaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProductReceivedOthersPanel extends StatefulWidget {


  @override
  _ProductReceivedOthersPanelState createState() => _ProductReceivedOthersPanelState();
}

class _ProductReceivedOthersPanelState extends State<ProductReceivedOthersPanel> {
  Function deleteTX;
  final List<ProductReceivedOthers> _userTransactions = [];
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

  void _addNewTransaction(String invoice, DateTime date, int quantity, double amount, String code, String customerName, String address) {

    final newTX = ProductReceivedOthers(
        id: DateTime.now().toString(),
        customerInfoId: idOfAuditSelection,
        invoice: invoice,
        date: date,
        amount: amount,
        code: code,
        quantity: quantity,
        customerName: customerName,
        address: address
    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.productReceivedOthersList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {
    if(counter >= i){
      Get.back();
      return;
    }

    print('Product Received ');




    try {
      Map<String, dynamic> parameters= {
        "CustomerInfoID": idOfAuditSelection,
        "CustomerName": _userTransactions[counter].customerName,
        "Address": _userTransactions[counter].address,
        "Date": _userTransactions[counter].date,
        "Amount": _userTransactions[counter].amount,
        "Invoice": _userTransactions[counter].invoice,
        "Code": _userTransactions[counter].code,
        "Quantity": _userTransactions[counter].quantity.toInt(),
        "Amount": _userTransactions[counter].amount.toInt()
      };
      print(parameters);
      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/product_received_others',queryParameters: parameters);
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
      AuditData.Owninstance.productReceivedList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: ProductReceivedOthersTransition(_addNewTransaction),
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
          'Product Received Others',
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
                    child: ProductReceivedOthersTransitionList(

                      AuditData.Owninstance.productReceivedOthersList,
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
            padding: EdgeInsets.only(bottom: 80.0),
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
