import 'package:audit_findings_app/Model/codeDataInInformationModel.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:audit_findings_app/Views/audit_selection_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeRegistrationPanel extends StatefulWidget {
  @override
  _CodeRegistrationPanelState createState() => _CodeRegistrationPanelState();
}

class _CodeRegistrationPanelState extends State<CodeRegistrationPanel> {
  int selectedRadio;
  int selectFFRadio;
  String codeData;
  CodeDataMode customer;
  var creditLimit = TextEditingController();
  var creditDays = TextEditingController();
  var moMSOName = TextEditingController();
  var aEAMName = TextEditingController();
  var zSMRSMName = TextEditingController();
  var sMName = TextEditingController();
  var customerName = TextEditingController();
  var address = TextEditingController();
  var contactNumber = TextEditingController();
  var asPerACI = TextEditingController();
  var gap = TextEditingController();
  var damagedStockController = TextEditingController();
  var smsDue = TextEditingController();
  String userID;
  double asPerCustomer;
  int totalStock;
  int freshStock;
  int damagedStock;
  String businessWithOtherCode;


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

  double getGapValue(){
    double asPerACIValue;
    try{
      asPerACIValue = double.parse(asPerACI.text);
    }catch(e){
      asPerACIValue = 0.0;
    }
    return asPerACIValue - asPerCustomer;
  }

  int getDamagedStockValue(){
    if(totalStock == null || freshStock == null){
      damagedStock = 0;
      return 0;
    }
    damagedStock = (totalStock - freshStock);
    return damagedStock;
  }

  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
    selectFFRadio = 1;
  }

  setSelectedRadio(int val){
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedFFRadio(int val){
    setState(() {
      selectFFRadio = val;
    });
  }
  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString('loginToken');
    userID = prefs.getString('userId');
    print(prefs.getString('password'));
    print(token);

  }

  void setAuditSelectionId(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idOfAuditSelection', value);

  }
  void onSubmitPressed() async{
    print('submit button pressed');
    try {
      var parameters = {
        "CustomerCode" : customer.customerCode,
        "CustomerName" : customer.customerName,
        "CreditLimit" : customer.creditLimit,
        "CreditDays" : customer.creditDays,
        "MoMsoCode" : "",
        "MoMsoName" : customer.moMSOName,
        "AeAmCode" : "",
        "AeAmName" : customer.aEAMName,
        "ZsmRsmCode" : "",
        "ZsmRsmName": customer.zSMRSMName,
        "SmCode" : "",
        "SmName" : customer.sMName,
        "Address" : customer.aaddress,
        "ContactNo" : customer.contactNumber,
        "SmsDue" : customer.smsDue,
        "AsPerAci" : customer.asPerACI,
        "AsPerCustomer": asPerCustomer.toString(),
        "Gap" : getGapValue().toString(),
        "TotalStock" : totalStock.toString(),
        "FreshStock" : freshStock.toString(),
        "DamagedStock" : damagedStock.toString(),
        "SalesProcceedsThroughTmr" : selectedRadio,
        "SalesProcceedsThroughTmr2" : selectFFRadio,
        "BusinessWithOtherCode" : businessWithOtherCode,
        "EntryBy" : userID,
        "AuditDate": DateFormat.yMd().format(currentDate)
      };

      var response = await Dio().post(
          'http://116.68.205.74/creditaudit/api/save_customer_info', data: parameters);
      print(response.statusCode);
      if (response.statusCode == 200){
        print(response.data["data"]["id"]);
        await setAuditSelectionId(response.data["data"]["id"].toString());
        Get.toNamed('/auditSelectionPanel');

      }


    }
    catch (e){
        print(e);
    }

  }
  void getHttp() async {

  print('Test ');


      try {
        var response = await Dio().post(
            'http://116.68.205.74/creditaudit/api/customer_info?CustomerCode=$codeData');
        print(response.data["data"][0]);
        var i = response.data["data"][0];
        customer = CodeDataMode(customerCode: i["CustomerCode"],customerName: i["CustomerName"], creditLimit: i["CreditLimit"],
          creditDays: i["CreditDays"], moMSOName: i["MOName"], aEAMName: i["AEName"], zSMRSMName: i["ZSMName"],
          sMName: i["SmName"], aaddress: i["Address"],asPerACI: i["AsPerACI"], smsDue: i["SmsDue"]
        );
        DataFromCode.customerName = i["CustomerName"];
        DataFromCode.address = i["Address"];
        setState(() {
          customerName.text = customer.customerName;
          creditLimit.text = customer.creditLimit;
          creditDays.text = customer.creditDays;
          moMSOName.text = customer.moMSOName;
          aEAMName.text = customer.aEAMName;
          zSMRSMName.text = customer.zSMRSMName;
          sMName.text = customer.sMName;
          address.text = customer.aaddress;
          contactNumber.text = customer.contactNumber;
          asPerACI.text = customer.asPerACI;
          smsDue.text = customer.smsDue == null? 0:customer.smsDue;
          getToken();

        });

      }
      catch (e){

      }


  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

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

                          Center(

                            child: Container(
                              height: 50,
                              child: Card(
                                color: Colors.green[300],
                                child: Center(child: Text('Information panel')),
                              ),
                            ),
                          ),
                          SizedBox(
                            height:10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "Enter Code",
                                    filled: true,
                                    fillColor: Colors.white,

                                  ),
                                  onChanged: (val){
                                    setState(() {
                                      codeData = val;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Text(DateFormat.yMMMd().format(currentDate)),
                                    RaisedButton(
                                    onPressed: () => _selectDate(context),
                                    child: Text('Select date')
                                  ),
                                ]
                                ),
                              ),
                            ]
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
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: customerName,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Customer Name",
                              filled: true,
                              fillColor: Colors.white,

                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Flexible(
                                  child: TextField(
                                    controller: creditLimit,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "Credit Limit",
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
                                    controller: creditDays,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "Credit Days",
                                      filled: true,
                                      fillColor: Colors.white,

                                    ),
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
                                    controller: moMSOName,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "MO/MSO Name",
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
                                    controller: aEAMName,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "AE/AM Name",
                                      filled: true,
                                      fillColor: Colors.white,

                                    ),
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
                                    controller: zSMRSMName,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "ZSM/RSM Name",
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
                                    controller: sMName,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "SM Name",
                                      filled: true,
                                      fillColor: Colors.white,

                                    ),
                                  ),
                                ),
                              ]
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: address,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Address",
                              filled: true,
                              fillColor: Colors.white,

                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Flexible(
                                  child: TextField(
                                    controller: contactNumber,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "Contact Number",
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
                                    controller: smsDue,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "SMS Due",
                                      filled: true,
                                      fillColor: Colors.white,

                                    ),
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
                                    controller: asPerACI,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      labelText: "As Per ACI",
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
                                    onChanged: (val){
                                      setState(() {
                                        // print(val);
                                        try {
                                          asPerCustomer = double.parse(val);
                                        }catch(e){
                                          asPerCustomer = 0;
                                        }
                                        print(asPerCustomer);
                                        gap.text = getGapValue().toString();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: "As Per Customer",
                                      filled: true,
                                      fillColor: Colors.white,

                                    ),
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
                                    controller: gap,
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
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Total Stock",
                                      filled: true,
                                      fillColor: Colors.white,

                                    ),
                                    onChanged: (val){
                                      setState(() {
                                        totalStock = int.parse(val);

                                        damagedStockController.text = getDamagedStockValue().toString();
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
                                    onChanged: (val){
                                      setState(() {
                                        freshStock = int.parse(val);
                                        damagedStockController.text = getDamagedStockValue().toString();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Fresh Stock",
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
                                    controller: damagedStockController,
                                    enabled: false,
                                    keyboardType: TextInputType.number,
                                    // onChanged: (val){
                                    //   setState(() {
                                    //     damagedStock = int.parse(val);
                                    //   });
                                    // },
                                    decoration: InputDecoration(
                                      labelText: "Damaged Stock",
                                      filled: true,
                                      fillColor: Colors.white,

                                    ),
                                  ),
                                ),
                              ]
                          ),

                          SizedBox(height: 10),
                          Text('Sales Proceeds realized through TMR: '),
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: [
                              Text('Yes'),
                              Radio(
                              value: 1,
                              groupValue: selectedRadio,
                              activeColor: Colors.green,
                              onChanged: (val){
                                print("Radio $val");
                                setSelectedRadio(val);
                              },
                            ),
                              Text('No'),
                              Radio(
                                value: 2,
                                groupValue: selectedRadio,
                                activeColor: Colors.green,
                                onChanged: (val){
                                  print("Radio $val");
                                  setSelectedRadio(val);
                                },
                              ),
                            ]
                          ),

                          ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                Text('FF'),
                                Radio(
                                  value: 1,
                                  groupValue: selectFFRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val){
                                    print("Radio FF $val");
                                    setSelectedFFRadio(val);
                                  },
                                ),
                                Text('DFC'),
                                Radio(
                                  value: 2,
                                  groupValue: selectFFRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val){
                                    print("Radio FF $val");
                                    setSelectedFFRadio(val);
                                  },
                                ),
                              ]
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Business with other Codes",
                              filled: true,
                              fillColor: Colors.white,
                            ),
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
