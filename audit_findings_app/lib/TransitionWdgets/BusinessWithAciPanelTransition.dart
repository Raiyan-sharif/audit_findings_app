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
  final totalDueController = TextEditingController();
  final overDueController = TextEditingController();
  final overDue120Controller = TextEditingController();
  final ageController = TextEditingController();



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
      int.parse(ageController.text)
    );
    Navigator.of(context).pop();
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
            crossAxisAlignment: CrossAxisAlignment.end,
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
              TextField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                controller: customerNameController,
                onSubmitted: (_) => submitData(),

              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Total Due'),
                controller: totalDueController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),

              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Over Due',
                ),

                controller: overDueController,
                onSubmitted: (_) => submitData(),

              ),

              SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: '120+ Over Due',
                ),
                keyboardType: TextInputType.number,

                controller: overDue120Controller,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,

                controller: ageController,
                onSubmitted: (_) => submitData(),
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
