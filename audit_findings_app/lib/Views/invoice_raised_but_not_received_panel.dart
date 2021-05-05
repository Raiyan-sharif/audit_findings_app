import 'package:audit_findings_app/Model/wrong_payment_model.dart';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/TransactionListWidgets/InvoiceRaisedButNotReceivedTransitionList.dart';
import 'package:audit_findings_app/TransitionWdgets/InvoiceRaisedButNotReceivedTransition.dart';
import 'package:audit_findings_app/Views/view_edit_report.dart';
import 'package:audit_findings_app/Views/wrong_payment_transitions.dart';
import 'package:audit_findings_app/Views/wrong_transaction_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class InvoiceRaisedButNotReceivedPanel extends StatefulWidget {


  @override
  _InvoiceRaisedButNotReceivedPanelState createState() => _InvoiceRaisedButNotReceivedPanelState();
}

class _InvoiceRaisedButNotReceivedPanelState extends State<InvoiceRaisedButNotReceivedPanel> {
  Function deleteTX;
  final List<InvoiceRaisedNotReceived> _userTransactions = [];
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

  void _addNewTransaction(DateTime date, double amount, String invoice, String depositConfirmation) {
    // String id;
    // String customerInfoId;
    // DateTime date;
    // double amount;
    // String code;
    // String tMR;
    final newTX = InvoiceRaisedNotReceived(
        id: DateTime.now().toString(),
        customerInfoId: idOfAuditSelection,
        invoice: invoice,
        date: date,
        amount: amount,
        depositConfirmation: depositConfirmation
    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.invoiceRaisedNotReceivedList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {
    if(counter >= i){
      Get.back();
      return;
    }

    print('Test ');
    print(idOfAuditSelection);
    print(_userTransactions[counter].date);
    print(_userTransactions[counter].amount);
    print(_userTransactions[counter].invoice);

    String confirmation = _userTransactions[counter].depositConfirmation == "2" ? 'Y' : 'N';
    print(confirmation);


    try {
      Map<String, dynamic> parameters= {
        "CustomerInfoID": idOfAuditSelection,
        "Date": _userTransactions[counter].date,
        "Amount": _userTransactions[counter].amount,
        "Invoice": _userTransactions[counter].invoice,
        "DepotConfirmation": confirmation
      };
      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/invoice_raised_not_received',queryParameters: parameters);
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
      AuditData.Owninstance.invoiceRaisedNotReceivedList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: InvoiceRaisedButNotReceivedTransition(_addNewTransaction),
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
          'Invoice Raised',
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
                    child: InvoiceRaisedButNotReceivedTransitionList(
                      AuditData.Owninstance.invoiceRaisedNotReceivedList,
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
