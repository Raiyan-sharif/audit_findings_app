import 'dart:io';

import 'package:audit_findings_app/Model/codeDataInInformationModel.dart';
import 'package:audit_findings_app/Services/dataFromCode.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class StockWithFFTransision extends StatefulWidget {
  final Function addTx;

  StockWithFFTransision(this.addTx);
  @override
  _StockWithFFTransisionState createState() => _StockWithFFTransisionState();
}

class _StockWithFFTransisionState extends State<StockWithFFTransision> {

  final ffController = TextEditingController();
  final noOfWirehousController = TextEditingController();
  final addressWirehousController = TextEditingController();
  final invoiceController = TextEditingController();
  final quantityController = TextEditingController();
  final amountControlller = TextEditingController();

  DateTime selectedDate;

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
    var quantity;
    // print(double.parse(amountControlller.text));

    if (!amountControlller.text.isEmpty) {
      enteredAmount = double.parse(amountControlller.text);
    }
    else {
      enteredAmount = -1;
    }
    if(!quantityController.text.isEmpty){
      quantity = int.parse(quantityController.text);
    }
    else {
      quantity = -1;
    }

    if (ffController.text.isEmpty || enteredAmount <= 0 || selectedDate == null ) {
      return;
    }
//String invoice, int quantity, double amount, String ffName, String noOfWareHouse, String address,File image, DateTime date
    widget.addTx(
      invoiceController.text,
      quantity,
      enteredAmount,
      ffController.text,
      noOfWirehousController.text,
      addressWirehousController.text,
      _image,
      selectedDate,
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Invoice#',
                ),

                controller: invoiceController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Quantity'),
                controller: quantityController,
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
                  labelText: 'FF Name',
                ),

                controller: ffController,
                onSubmitted: (_) => submitData(),
//                      onChanged: (value){
//                        this.titleInput = value;
//                      },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Wirehouse Number',
                ),

                controller: noOfWirehousController,
                onSubmitted: (_) => submitData(),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Wirehouse Address',
                ),

                controller: addressWirehousController,
                onSubmitted: (_) => submitData(),
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
