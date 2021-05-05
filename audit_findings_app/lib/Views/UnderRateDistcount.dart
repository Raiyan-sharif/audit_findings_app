import 'package:audit_findings_app/Model/codeDataInInformationModel.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/Views/audit_selection_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnderRateDistcountPanel extends StatefulWidget {
  @override
  _UnderRateDistcountPanelState createState() => _UnderRateDistcountPanelState();
}

class _UnderRateDistcountPanelState extends State<UnderRateDistcountPanel> {

  DateTime selectedDate;

  String amount;
  String quantity;
  String invoice;
  String idOfAuditSelection;
  String remarks;
  String productName;
  String rate;
  String dp;

  var amountController = TextEditingController();
  var gapController = TextEditingController();

  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }


  String getAmmount(){
    if(quantity.isEmpty || rate.isEmpty){
      return "0";
    }
    else{
      try{
        double qualtityDouble = double.parse(quantity);
        double rateDouble = double.parse(rate);
        double result = qualtityDouble * rateDouble;
        return result.toString();
      }catch(e){
        return "0";
      }
    }
  }
  String getGAPAmount(){
    if(quantity.isEmpty || rate.isEmpty || dp.isEmpty){
      return "0";
    }
    else{
      try{
        double qualtityDouble = double.parse(quantity);
        double rateDouble = double.parse(rate);
        double dpValue = double.parse(dp);
        double result =  (qualtityDouble * rateDouble) - (qualtityDouble * dpValue)  ;
        return result.toString();
      }catch(e){
        return "0";
      }
    }
  }
  Future<String> getAuditSelectionId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('idOfAuditSelection');
    return data;
  }


  @override
  void initState() {
    super.initState();
    getRequiredData();
  }
  void getRequiredData() async{
    idOfAuditSelection = await getAuditSelectionId();
  }
  void onSubmitPressed() async{
    print('submit button pressed');
    try {
      var parameters = {

        "Invoice": invoice,
        "Quantity" : quantity.toString(),
        "Amount" : amountController.text,
        "CustomerInfoID": idOfAuditSelection,
        "Remarks": remarks,
        "ProductName": productName,
        "Rate": rate,
        "DP":dp,
        "GAP":gapController.text
      };

      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/underrate_product_sold', data: parameters);
      print(response.data);
      if (response.statusCode == 200){
        Get.back();
      }


    }
    catch (e){
      print(e);
    }

  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          selectedDate = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    final appbar = AppBar(
      title: Center(
        child: Text(
          'Under rated Product Sold',
        ),
      ),
      backgroundColor: Colors.green[500],
      leading: IconButton(
          icon: Icon(Icons.backspace),
          onPressed: () {
            Get.back();
          }
      ) ,

    );

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: appbar,
          body: Container(
            height: height,
            width: width,


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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Flexible(
                                child: TextField(

                                  decoration: InputDecoration(
                                    labelText: "Product Name",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      productName = value;
                                    });
                                  },
                                ),
                              ),


                            ]
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.number,

                                  decoration: InputDecoration(
                                    labelText: "Quantity",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      quantity = value;
                                      amountController.text = getAmmount();
                                      gapController.text = getGAPAmount();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Rate",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState((){
                                      rate = value;
                                      amountController.text = getAmmount();
                                      gapController.text = getGAPAmount();
                                    });
                                  },
                                ),
                              ),
                            ]
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Flexible(
                                child: TextField(
                                  controller: amountController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: "Amount",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),

                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "DP",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      dp = value;
                                      gapController.text = getGAPAmount();
                                    });
                                  },
                                ),
                              ),
                            ]
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Flexible(
                                child: TextField(
                                  controller: gapController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: "GAP",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),

                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextField(

                                  decoration: InputDecoration(
                                    labelText: "Remarks",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      remarks = value;
                                    });
                                  },
                                ),
                              ),
                            ]
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
                            onSubmitPressed();
                          },
                          child: const Text('Submit', style: TextStyle(fontSize: 20,)),
                        ),
                      ]
                  ),
                ),

              ),
            ),
          ),
        ),
      ),
    );
  }
}
