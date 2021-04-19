//OtherProblemsPanel
import 'dart:convert';

import 'package:audit_findings_app/Model/codeDataInInformationModel.dart';
import 'package:audit_findings_app/Services/audit_selection_panel_data.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/Views/audit_selection_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherProblemsPanel extends StatefulWidget {
  @override
  _OtherProblemsPanelState createState() => _OtherProblemsPanelState();
}

class _OtherProblemsPanelState extends State<OtherProblemsPanel> {



  String idOfAuditSelection;

  List<OtherObservationItem > observarionListDictionary = [] ;
  var description = [];

 void setDataToList(String description, bool isChecked){
   var item = new OtherObservationItem(
       description: description,
       isChecked: isChecked
   );
   observarionListDictionary.add(item);

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
    setDataToList("Long Lag time between collection and deposit of payment", false);
    setDataToList("Customer Name Changed", false);
    setDataToList("Customer Address Changed", false);
    setDataToList("Practices of Using counterfeit invoice while delivering goods", false);
    setDataToList("Payment entry made through TCM without collecting money physically", false);
    setDataToList("Proprietor Changed", false);
    setDataToList("Early Product Placement", false);
    setDataToList("Invoice raised without customer consent", false);
    setDataToList("Operating both cash/credit line against single customer", false);
    setDataToList("Excessive credit limit facilitated", false);
    setDataToList("Business Closed", false);
    setDataToList("Recommended for Legal Action", false);
    setDataToList("Product placement after season", false);

  }
  void getRequiredData() async{
    idOfAuditSelection = await getAuditSelectionId();
  }
  void onSubmitPressed() async{
    List<Map> options;


    print('submit button pressed');
    try {
      var parameters = {

        "CustomerInfoID": idOfAuditSelection,
        "Observations" : jsonEncode( observarionListDictionary)
      };

      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/other-observations', data: parameters);
      print(response.data);
      if (response.statusCode == 200){
        Get.back();
      }


    }
    catch (e){
      print(e);
    }

  }



  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    final appbar = AppBar(
      title: Center(
        child: Text(
          'Other Problems',
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
          floatingActionButton: RaisedButton(

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.green[500])
            ),
            textColor: Colors.white,
            color: Colors.green[500],
            onPressed: ()  async{

              await onSubmitPressed();


            },
            child: const Text('SUBMIT', style: TextStyle(fontSize: 20,)),
          ),
          body:observarionListDictionary.isEmpty
              ? Column(
            children: [
              Text(
                'No Transaction added yet!',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
                height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top ) * 0.4,
              )
            ],
          )
              : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: FittedBox(
                        child: Checkbox(
                          value: observarionListDictionary[index].isChecked,
                          onChanged: (value){
                            setState(() {
                              observarionListDictionary[index].isChecked = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    observarionListDictionary[index].description,
                    style: Theme.of(context).textTheme.title,
                  ),


                ),
              );
            },
            itemCount: observarionListDictionary.length,
//        children: transactions .map((tx) {

//
//        }).toList(),
          )
        ),
      ),
    );
  }
}
