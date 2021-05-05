import 'package:audit_findings_app/Model/codeDataInInformationModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusinessWithAciPanelTransition extends StatefulWidget {
  final Function addTx;

  BusinessWithAciPanelTransition(this.addTx);
  @override
  _BusinessWithAciPanelTransitionState createState() => _BusinessWithAciPanelTransitionState();
}

class _BusinessWithAciPanelTransitionState extends State<BusinessWithAciPanelTransition> {

  final otherCodeController = TextEditingController();
  final customerNameController = TextEditingController();
  var customer = CodeDataMode();
  final totalDueController = TextEditingController();
  final overDueController = TextEditingController();
  final overDue120Controller = TextEditingController();
  final ageController = TextEditingController();
  final creditTypeController = TextEditingController();



  DateTime selectedDate;

  void submitData() {


    print("Ok");
    if (otherCodeController.text.isEmpty) {
      return;
    }
//String code,int totalDue,int overDue,int overDue120,int age
    widget.addTx(
      otherCodeController.text,
      int.parse(totalDueController.text),
      int.parse(overDueController.text),
      int.parse(overDue120Controller.text),
      int.parse(ageController.text),
      creditTypeController.text
    );
    Navigator.of(context).pop();
  }
  void getHttp() async {

    print('Test ');


    try {
      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/customer_info?CustomerCode=${otherCodeController.text}');
      print(response.data["data"][0]);
      var i = response.data["data"][0];
      customer = CodeDataMode(customerCode: i["CustomerCode"],customerName: i["CustomerName"], creditLimit: i["CreditLimit"],
          creditDays: i["CreditDays"], moMSOName: i["MOName"], aEAMName: i["AEName"], zSMRSMName: i["ZSMName"],
          sMName: i["SmName"], aaddress: i["Address"],asPerACI: i["AsPerACI"], smsDue: i["SmsDue"],
       totalDue: i["TotalDue"].toString(), overDue: i["OverDue"].toString(), overDue120: i["OverDue120"].toString(),age: i["Age"].toString(), creditType: i["CreditType"]
      );

      print("ok");
      setState(() {
        customerNameController.text = customer.customerName;
        totalDueController.text = customer.totalDue;
        overDueController.text = customer.overDue;
        overDue120Controller.text = customer.overDue120;
        ageController.text = customer.age;
        creditTypeController.text = customer.creditType;
      });

    }
    catch (e){

      print(e);
    }


  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Other Code',
                ),

                controller: otherCodeController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green[500])
                ),
                textColor: Colors.white,
                color: Colors.green[500],
                onPressed: (){
                  getHttp();
                },
                child: const Text('Get data', style: TextStyle(fontSize: 20,)),
              ),
              SizedBox(height: 10),
              TextField(
                enabled: false,
                decoration: InputDecoration(labelText: 'Customer Name',filled: true),
                controller: customerNameController,


              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(labelText: 'Total Due',filled: true),
                controller: totalDueController,
                keyboardType: TextInputType.number,

              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                enabled: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Over Due', filled: true
                ),

                controller: overDueController,

              ),

              SizedBox(
                height: 10,
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: '120+ Over Due',filled: true
                ),
                keyboardType: TextInputType.number,

                controller: overDue120Controller,


              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Age',filled: true
                ),
                keyboardType: TextInputType.number,

                controller: ageController,

//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              SizedBox(
                height: 10,
              ),
              //creditTypeController
              TextField(
                enabled: false,
                decoration: InputDecoration(
                    labelText: 'Customer Type',filled: true
                ),
                keyboardType: TextInputType.number,

                controller: creditTypeController,

//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),

              SizedBox(
                height: 50,
              ),

              SizedBox(
                height: 50,
              ),

              RaisedButton(
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
