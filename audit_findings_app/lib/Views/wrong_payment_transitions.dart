import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class WrongPaymentTransition extends StatefulWidget {
  final Function addTx;

  WrongPaymentTransition(this.addTx);
  @override
  _WrongPaymentTransitionState createState() => _WrongPaymentTransitionState();
}

class _WrongPaymentTransitionState extends State<WrongPaymentTransition> {
  final titleController = TextEditingController();
  final titleController2 = TextEditingController();
  final amountControlller = TextEditingController();
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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

    widget.addTx(
      selectedDate,
      titleController.text,
      titleController2.text,
      double.parse(amountControlller.text),
      _image
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
                  labelText: 'Code',
                ),

                controller: titleController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
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
                      'Choose Date of Code',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  )
                ],
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'TMR#',
                ),

                controller: titleController2,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              RaisedButton(
                onPressed: getImage,
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
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
