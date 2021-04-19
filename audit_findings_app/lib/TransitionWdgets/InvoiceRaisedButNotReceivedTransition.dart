import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceRaisedButNotReceivedTransition extends StatefulWidget {
  final Function addTx;

  InvoiceRaisedButNotReceivedTransition(this.addTx);
  @override
  _InvoiceRaisedButNotReceivedTransitionState createState() => _InvoiceRaisedButNotReceivedTransitionState();
}

class _InvoiceRaisedButNotReceivedTransitionState extends State<InvoiceRaisedButNotReceivedTransition> {
  final titleController = TextEditingController();
  final amountControlller = TextEditingController();
  bool isChecked = false;

  DateTime selectedDate;

  void submitData() {
    final enteredTitle = titleController.text;
    var enteredAmount;
    print(selectedDate);
    print(titleController.text);
    print(double.parse(amountControlller.text));

    if (!amountControlller.text.isEmpty) {
      enteredAmount = double.parse(amountControlller.text);
    } else {
      enteredAmount = -1;
    }

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }
//DateTime date, double amount, String invoice, String depositConfirmation
    widget.addTx(
      selectedDate,
      double.parse(amountControlller.text),
      titleController.text,
      isChecked.toString(),
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
                  labelText: 'Invoice',
                ),

                controller: titleController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountControlller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.amountInput = value;
//                      },
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: (){

                },
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value){
                        setState(() {
                          isChecked = value;
                        });
                      },
                ),
                    Text('Confirmation From Deposit'),

                  ]
                ),
              ),
              SizedBox(
                height: 50,
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
