import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PendingIncentiveTransition extends StatefulWidget {
  final Function addTx;

  PendingIncentiveTransition(this.addTx);
  @override
  _PendingIncentiveTransitionState createState() => _PendingIncentiveTransitionState();
}

class _PendingIncentiveTransitionState extends State<PendingIncentiveTransition> {

  final remarksController = TextEditingController();
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



  void submitData() {

    var enteredAmount;

    // print(double.parse(amountControlller.text));

    if (!amountControlller.text.isEmpty) {
      enteredAmount = double.parse(amountControlller.text);
    }
    else {
      enteredAmount = -1;
    }


    if (remarksController.text.isEmpty || enteredAmount <= 0) {
      return;
    }
//String invoice, DateTime date, int quantity, double amount, String code
    widget.addTx(
      remarksController.text,
      enteredAmount,
      _image
    );
    Navigator.of(context).pop();
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
                  labelText: 'Remarks',
                ),

                controller: remarksController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              SizedBox(
                height: 10,
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
