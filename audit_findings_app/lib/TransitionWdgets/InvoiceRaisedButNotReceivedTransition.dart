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
  int selectedRadio;

  DateTime selectedDate;

  setSelectedRadio(int val){
    setState(() {
      selectedRadio = val;
    });
  }

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
    print(selectedRadio);
//DateTime date, double amount, String invoice, String depositConfirmation
    widget.addTx(
      selectedDate,
      double.parse(amountControlller.text),
      titleController.text,
      selectedRadio.toString()
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
            crossAxisAlignment: CrossAxisAlignment.center,

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
              SizedBox(height: 10),
              Text('Confirmation From depot: '),
              ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    Text('UnDelivered'),
                    Radio(
                      value: 1,
                      groupValue: selectedRadio,
                      activeColor: Colors.green,
                      onChanged: (val){
                        print("Radio $val");
                        setSelectedRadio(val);
                      },
                    ),
                    Text('Delivered'),
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
              SizedBox(
                height: 30,
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
