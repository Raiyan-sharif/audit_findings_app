import 'dart:io';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/TransactionListWidgets/RSMRecoveryCommitmentTransitionList.dart';
import 'package:audit_findings_app/TransitionWdgets/RSMRecoveryCommitmentTransition.dart';
import 'package:dio/dio.dart' as doi;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RSMRecoveryCommitmentPanel extends StatefulWidget {


  @override
  _RSMRecoveryCommitmentPanelState createState() => _RSMRecoveryCommitmentPanelState();
}

class _RSMRecoveryCommitmentPanelState extends State<RSMRecoveryCommitmentPanel> {
  Function deleteTX;
  final List<RSMRecoveryCommitment> _userTransactions = [];
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

  void _addNewTransaction(DateTime date, int amount, File _image) {

    final newTX = RSMRecoveryCommitment(
        id: DateTime.now().toString(),
        customerInfoId: idOfAuditSelection,
        date: date,
        amount: amount,
        fileData: _image
    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.rSMRecoveryCommitmentList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {
    if(counter >= i){
      Get.offNamed('/home');
      return;
    }

    print('RSMRecoveryCommitmentPanel');




    try {
      Map<String, dynamic> parameters= {
        "CustomerInfoID": idOfAuditSelection,
        "Amount": _userTransactions[counter].amount,
        "Date" :_userTransactions[counter].date
      };
      doi.FormData formData = doi.FormData.fromMap({
        "Image": await doi.MultipartFile.fromFile(_userTransactions[counter].fileData.path, filename: "${DateTime.now().toString()}_file"),
      });
      var response = await doi.Dio().post(
          'http://116.68.205.74/creditaudit/api/recovery_commitment_rsm',queryParameters: parameters,data: formData);
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
      AuditData.Owninstance.rSMRecoveryCommitmentList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: RSMRecoveryCommitmentTransition(_addNewTransaction),
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
          'RSM Commitment Recovery',
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
                    height: height * 0.7,
                    child: RSMRecoveryCommitmentTransitionList(
                      AuditData.Owninstance.rSMRecoveryCommitmentList,
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green[500],
            child: Icon(Icons.add),
            // onPressed: () => getIdForCustomerInfoId(),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ),
      ),
    );
  }
}
