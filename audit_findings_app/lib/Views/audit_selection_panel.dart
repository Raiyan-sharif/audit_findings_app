import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AuditSelectionPanel extends StatefulWidget {
  @override
  _AuditSelectionPanelState createState() => _AuditSelectionPanelState();
}

class _AuditSelectionPanelState extends State<AuditSelectionPanel> {

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return SafeArea(
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
                        height: 30,
                      ),

                      Center(

                        child: Container(
                          height: 50,
                          child: Card(
                            color: Colors.green[300],
                            child: Center(child: Text('Audit Selection panel')),
                          ),
                        ),
                      ),
                      SizedBox(
                        height:30,
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: () {
                                    Get.toNamed('/wrong_payment');
                                  },
                                  child:

                                  Text('Wrong Payment Posting')



                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: () {
                                    Get.toNamed('/invoice_raised_but_not_received');

                                  },
                                  child:
                                  Text('Invoice Raised but Not Received by Original Customer')
                              ),
                            ),
                          ]
                      ),
                      SizedBox(
                        height:50,
                      ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(

                                  side: BorderSide(color: Colors.grey[400], width: 1)
                              ),
                              textColor: Colors.black,
                              color: Color(0xff7EC9C9),
                              onPressed: () {
                                Get.toNamed('/payment_made_not_deposited');

                              },
                              child:

                              Text('Payment Made But Not Received')



                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(

                                  side: BorderSide(color: Colors.grey[400], width: 1)
                              ),
                              textColor: Colors.black,
                              color: Color(0xff7EC9C9),
                              onPressed: () {
                                Get.toNamed('/shifted_to_sd');
                              },
                              child:
                              Text('Shifted to SD/SCP')
                          ),
                        ),
                      ]
                  ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: () {
                                    Get.toNamed('/ff_stock');

                                  },
                                  child: Text('Stock With FF')
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: () {
                                    Get.toNamed('/product_received_others');
                                  },
                                  child:
                                  Text('Despite Having OD/fully utilized credits product received from others')
                              ),
                            ),
                          ]
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: () {
                                    Get.toNamed('/underrate_product_sold');
                                  },
                                  child: Text('Underrate/Product Sold @discount rate')
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: (){
                                    Get.toNamed('/product_received');
                                  },
                                  child:
                                  Text('Product Received by respective FF & Supplied to another Customer')
                              ),
                            ),
                          ]
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: () {
                                    Get.toNamed('/pending_inventive_claim');
                                  },
                                  child: Text('Pending Incentive Claim')
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(

                                      side: BorderSide(color: Colors.grey[400], width: 1)
                                  ),
                                  textColor: Colors.black,
                                  color: Color(0xff7EC9C9),
                                  onPressed: (){
                                    Get.toNamed('/other-observations');
                                  },
                                  child:
                                  Text('Other Problems')
                              ),
                            ),
                          ]
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        minWidth: width/2,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green[500])
                          ),
                          textColor: Colors.white,
                          color: Colors.green[500],
                          onPressed: ()  {
                            Get.toNamed("/business_with_aci");
                          },
                          child: const Text('NEXT', style: TextStyle(fontSize: 20,)),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),

                    ]
                ),
              ),

            ),
          ),
        ),
      ),
    );
  }
}
