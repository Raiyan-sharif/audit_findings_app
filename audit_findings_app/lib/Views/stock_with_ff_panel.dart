import 'package:audit_findings_app/Model/codeDataInInformationModel.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/Views/audit_selection_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockWithFFnPanel extends StatefulWidget {
  @override
  _StockWithFFnPanelState createState() => _StockWithFFnPanelState();
}

class _StockWithFFnPanelState extends State<StockWithFFnPanel> {

  DateTime selectedDate;
  String userID;
  String amount;
  String quantity;
  String invoice;
  String ofWarehouse;
  String ffName;
  String addressOfWarehouse;
  String idOfAuditSelection;


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
        "Date" : selectedDate.toString(),
        "Quantity" : quantity.toString(),
        "Amount" : amount.toString(),
        "FFName" : ffName,
        "NoOfWarehouse" : ofWarehouse,
        "Address": addressOfWarehouse,
        "CustomerInfoID": idOfAuditSelection,
      };

      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/ff_stock', data: parameters);
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
          'FF Stock Panel',
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
                                    labelText: "Invoice",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      invoice = value;
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
                                    labelText: "Quantity",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      quantity = value;
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
                                    labelText: "Amount",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      amount = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextField(


                                  decoration: InputDecoration(
                                    labelText: "FF Name",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      ffName = value;
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

                                  decoration: InputDecoration(
                                    labelText: "# of Warehouse",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      ofWarehouse = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextField(

                                  decoration: InputDecoration(
                                    labelText: "Warehouse Address",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      addressOfWarehouse = value;
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
                          children: [
                            Expanded(
                              child: Text(
                                selectedDate == null
                                    ? 'No Date Choosen'
                                    : DateFormat.yMd().format(selectedDate),
                              ),
                            ),
                            FlatButton(
                              textColor: Theme.of(context).primaryColor,
                              child: Text(
                                'Choose Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _presentDatePicker,
                            )
                          ],
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
