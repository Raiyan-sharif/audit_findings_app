import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/TransactionListWidgets/BusinessWithAciPanelTransitionList.dart';
import 'package:audit_findings_app/TransactionListWidgets/ProductReceivedOthersTransitionList.dart';
import 'package:audit_findings_app/TransitionWdgets/BusinessWithAciPanelTransition.dart';
import 'package:audit_findings_app/TransitionWdgets/ProductReceivedOthersTransition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BusinessWithAciPanel extends StatefulWidget {


  @override
  _BusinessWithAciPanelState createState() => _BusinessWithAciPanelState();
}

class _BusinessWithAciPanelState extends State<BusinessWithAciPanel> {
  Function deleteTX;
  final List<BusinessWithACIModel> _userTransactions = [];
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




  void _addNewTransaction(String code,int totalDue,int overDue,int overDue120,int age, String creditType) {

    final newTX = BusinessWithACIModel(
      id: DateTime.now().toString(),
      customerId: idOfAuditSelection,
      code: code,
      customerName: DataFromCode.customerName,
      totalDue: totalDue,
      overDue: overDue,
      overDue120: overDue120,
      age: age,
      creditType: creditType
    );
    setState(() {
      // _userTransactions.add(newTX);
      AuditData.Owninstance.businessWithACIModelList.add(newTX);
      _userTransactions.add(newTX);
      i = _userTransactions.length;

    });
  }

  Future<void> getHttp() async {
    if(counter >= i){
      Get.toNamed("/recovery_commitment_customer");
      return;
    }

    print('Product Received ');




    try {
      Map<String, dynamic> parameters= {
        "CustomerInfoID": idOfAuditSelection,
        "CustomerName": DataFromCode.customerName,
        "Code": _userTransactions[counter].code,
        "TotalDue": _userTransactions[counter].totalDue,
        "OverDue": _userTransactions[counter].overDue,
        "OverDue120": _userTransactions[counter].overDue120,
        "Age": _userTransactions[counter].age,
        "CreditType": _userTransactions[counter].creditType

      };
      print(parameters);
      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/business_with_aci',queryParameters: parameters);
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
      AuditData.Owninstance.businessWithACIModelList.removeWhere((element) => element.id == id);
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: BusinessWithAciPanelTransition(_addNewTransaction),
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
          'Business With ACI',
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
                    child: BusinessWithAciPanelTransitionList(
                      AuditData.Owninstance.businessWithACIModelList,
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
