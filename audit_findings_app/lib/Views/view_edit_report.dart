import 'package:audit_findings_app/Views/audit_selection_panel.dart';
import 'package:audit_findings_app/Views/code_registration_panel.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
class ViewEditReport extends StatefulWidget {
  @override
  _ViewEditReportState createState() => _ViewEditReportState();
}

class _ViewEditReportState extends State<ViewEditReport> {
  String dropdownValue = 'Recovery';
  String dropdownValue2 = 'Recovery';
  String view_dropdownValue = 'Recovery';
  List<String> listValue;

  void getHttp() async {

    try {
      var response = await Dio().get(
          'http://116.68.205.74/creditaudit/api/report_type');
      print(response.data["data"],
      );
      for(var i in response.data["data"]){
        print(i["ReportTypeName"]);
        setState(() {
          listValue.add(i["ReportTypeName"]);
        });
      }
    }
    catch (e){

    }

  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    //getHttp();
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
            body: Container(
              height: height,
              width: width,

              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/login1.png"), fit: BoxFit.fill),

              ),
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

                          Image(
                            width: width,
                            height: height/4,
                            image: AssetImage("images/audit_image_view_edit.jpg"),
                          ),
                          SizedBox(
                            height:10,
                          ),

                          SizedBox(
                            height:30,
                          ),
                          Text('VIEW REPORT'),
                          Padding(
                            padding: EdgeInsets.only(left: 50,right: 50),
                            child: DropdownButton<String>(
                              value: view_dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  view_dropdownValue = newValue;
                                });
                              },
                              hint: Text('Report Type'),
                              items: <String>['Field Audit', 'Recovery']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                  onTap: (){
                                    print(value);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height:30,
                          ),
                          Text('ADD REPORT'),
                          Padding(
                            padding: EdgeInsets.only(left: 50,right: 50),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              hint: Text('Report Type'),
                              items: <String>['Field Audit', 'Recovery']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                  onTap: (){
                                    print(value);
                                    if(value == "Field Audit"){
                                      // Get.toNamed("/auditSelectionPanel",);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            CodeRegistrationPanel()),
                                      );

                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height:30,
                          ),
                          Text('EDIT REPORT'),
                          Padding(
                            padding: EdgeInsets.only(left: 50,right: 50),
                            child: DropdownButton<String>(
                              value: dropdownValue2,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  dropdownValue2 = newValue;

                                });
                              },
                              hint: Text('Report Type'),
                              items: <String>['Field Audit', 'Recovery']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height:30,
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
