import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/TransactionListWidgets/CustomerRecoveryCommittedTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/MORecoveryCommitmentTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/PendingIncentiveTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/ShiftedToSDTransactionList.dart';
import 'package:audit_findings_app/TransitionWdgets/CustomerRecoveryCommittedTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/MORecoveryCommitmentTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/PendingIncentiveTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/ShiftedToSDTransaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MORecoveryCommitmentPanel extends StatefulWidget {


  @override
  _MORecoveryCommitmentPanelState createState() => _MORecoveryCommitmentPanelState();
}

class _MORecoveryCommitmentPanelState extends State<MORecoveryCommitmentPanel> {
  Function deleteTX;
  final List<MORecoveryCommitment> _userTransactions = [];
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

  void _addNewTransaction(DateTime date, int amount) {

    final newTX = MORecoveryCommitment(
        id: DateTime.now().toString(),
        customerInfoId: idOfAuditSelection,
        date: date,
        amount: amount
    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.mORecoveryCommitmentList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {
    if(counter >= i){
      Get.toNamed("/recovery_commitment_rsm");
      return;
    }

    print('MORecoveryCommitmentPanel');




    try {
      Map<String, dynamic> parameters= {
        "CustomerInfoID": idOfAuditSelection,
        "Amount": _userTransactions[counter].amount,
      };
      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/recovery_commitment_mo',queryParameters: parameters);
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
      AuditData.Owninstance.mORecoveryCommitmentList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: MORecoveryCommitmentTransition(_addNewTransaction),
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
          'MO Commitment Recovery',
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
                    child: MORecoveryCommitmentTransitionList(
                      AuditData.Owninstance.mORecoveryCommitmentList,
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
