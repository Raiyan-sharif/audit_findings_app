import 'package:flutter/material.dart';
//import './question.dart';
//
void main() {
  runApp(MaterialApp(
      home: MyApp()
  ));
}
//import 'package:flutter/material.dart';
//
//void main() {
//  runApp(MyApp());
//}
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    double width=MediaQuery.of(context).size.width;
//    double height=MediaQuery.of(context).size.height;
//
//    return MaterialApp(
//      title: 'Flutter Demo',
//
//      home: Scaffold(
////        appBar: AppBar(
////
////          title: Text('Audit finding Application'),
////        ),
//
//
//        body: Scaffold(
//          body: Container(
//            decoration: BoxDecoration(
//              image: DecorationImage(image: AssetImage("images/login1.png"), fit: BoxFit.fill),
//
//            ),
//            height: height,
//            width: width,
//            child:  SingleChildScrollView(
//              child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                children:[
//                  SizedBox(
//                    height: 70,
//                  ),
//
//                  CircleAvatar(
//                    radius: 50,
//                    backgroundImage: AssetImage("images/aci_group_logo.png"),
//                  ),
//                  SizedBox(
//                    height:10,
//                  ),
//                   Card(
//                      elevation: 10,
//                      color: Colors.green[500],
//                      child: Padding(
//                        padding: EdgeInsets.all(5),
//                        child: Text('INSTAT AUDIT REPORTING',
//                          style: TextStyle(color: Colors.white),
//                        ),
//                      ),
//                    ),
//                  SizedBox(
//                    height:30,
//                  ),
//                Padding(
//                  padding: EdgeInsets.only(left: 50,right: 50),
//                  child: TextField(
//                    decoration: InputDecoration(
//                        border: InputBorder.none,
//                        hintText: 'User ID'
//                    ),
//                  ),
//                ),
//                  SizedBox(
//                    height:30,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 50,right: 50),
//                    child: TextField(
//                      decoration: InputDecoration(
//                          border: InputBorder.none,
//                          hintText: 'Password'
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    height:30,
//                  ),
//                  RaisedButton(
//                    textColor: Colors.white,
//                    color: Colors.green[500],
//                    onPressed: () {},
//                    child: const Text('LOGIN', style: TextStyle(fontSize: 20,)),
//                  )
//
//                ]
//              ),
//            ),
//          ),
//        ),
//
//      ),
//    );
//  }
//}
//


class MyApp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 24),
        child: Container(
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
                      children:[
                        SizedBox(
                          height: 70,
                        ),

                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/aci_group_logo.png"),
                        ),
                        SizedBox(
                          height:10,
                        ),
                         Card(
                            elevation: 10,
                            color: Colors.green[500],
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text('INSTAT AUDIT REPORTING',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        SizedBox(
                          height:30,
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 50,right: 50),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            hintText: 'User ID',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                        ),
                      ),
                        SizedBox(
                          height:30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 50,right: 50),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                hintText: 'Password',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),

                          ),
                        ),
                        SizedBox(
                          height:30,
                        ),
                        Row(
                          children: [
                            Text('Forgot password?'),
                            SizedBox(
                              height:10,
                            ),
                            Text('Click heres')
                          ],
                        ),
                        SizedBox(
                          height:30,
                        ),
                        ButtonTheme(
                          minWidth: width-151.4,

                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.green[500])
                            ),
                            textColor: Colors.white,
                            color: Colors.green[500],
                            onPressed: () {},
                            child: const Text('LOGIN', style: TextStyle(fontSize: 20,)),
                          ),
                        )

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
