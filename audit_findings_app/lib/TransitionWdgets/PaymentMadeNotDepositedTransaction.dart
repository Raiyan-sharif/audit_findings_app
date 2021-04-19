import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentMadeNotDepositedTransaction extends StatefulWidget {
  final Function addTx;

  PaymentMadeNotDepositedTransaction(this.addTx);
  @override
  _PaymentMadeNotDepositedTransactionState createState() => _PaymentMadeNotDepositedTransactionState();
}

class _PaymentMadeNotDepositedTransactionState extends State<PaymentMadeNotDepositedTransaction> {

  final tmrController = TextEditingController();
  final ffNameController = TextEditingController();

  final amountControlller = TextEditingController();


  DateTime selectedDate;

  void submitData() {

    var enteredAmount;
    final enteredTMR = tmrController.text;
    final enteredffName = ffNameController.text;
    print(double.parse(amountControlller.text));

    if (!amountControlller.text.isEmpty) {
      enteredAmount = double.parse(amountControlller.text);
    } else {
      enteredAmount = -1;
    }

    if (enteredTMR.isEmpty || enteredAmount <= 0 || selectedDate == null ) {
      return;
    }
//String invoice, DateTime date, double amount, String code
    widget.addTx(
      enteredffName,
      selectedDate,
      double.parse(amountControlller.text),
      enteredTMR,

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
              TextField(
                decoration: InputDecoration(
                  labelText: 'TMR#',
                ),

                controller: tmrController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'FF Name',
                ),

                controller: ffNameController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
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
