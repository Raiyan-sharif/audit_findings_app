import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UnderRateDiscountTransition extends StatefulWidget {
  final Function addTx;

  UnderRateDiscountTransition(this.addTx);
  @override
  _UnderRateDiscountTransitionState createState() => _UnderRateDiscountTransitionState();
}

class _UnderRateDiscountTransitionState extends State<UnderRateDiscountTransition> {



  final remarksController = TextEditingController();
  final rateController = TextEditingController();
  final invoiceController = TextEditingController();
  final quantityController = TextEditingController();
  final amountController = TextEditingController();
  final productNameController = TextEditingController();
  final dPController = TextEditingController();
  final gAPController = TextEditingController();


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

  String getAmmount(){
    if(quantityController.text.isEmpty || rateController.text.isEmpty){
      return "0";
    }
    else{
      try{
        double qualtityDouble = double.parse(quantityController.text);
        double rateDouble = double.parse(rateController.text);
        double result = qualtityDouble * rateDouble;
        return result.toString();
      }catch(e){
        return "0";
      }
    }
  }

  String getGAPAmount(){
    if(quantityController.text.isEmpty || rateController.text.isEmpty || dPController.text.isEmpty){
      return "0";
    }
    else{
      try{
        double qualtityDouble = double.parse(quantityController.text);
        double rateDouble = double.parse(rateController.text);
        double dpValue = double.parse(dPController.text);
        double result =  (qualtityDouble * rateDouble) - (qualtityDouble * dpValue)  ;
        return result.toString();
      }catch(e){
        return "0";
      }
    }
  }

  void submitData() {

    var enteredAmount;
    var quantity;
    // print(double.parse(amountControlller.text));
    print('Here');

    if (!amountController.text.isEmpty) {
      enteredAmount = double.parse(amountController.text);
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

    if (productNameController.text.isEmpty || enteredAmount <= 0) {
      return;
    }

    // String remarks,
    //     double amount,
    // String productName,
    // String quality,
    // String rate,
    // String dP,
    // String gAP,
    // File image
    widget.addTx(
      remarksController.text,
      enteredAmount,
      productNameController.text,
      quantityController.text,
      rateController.text,
      dPController.text,
      gAPController.text,
      _image,
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
                  labelText: 'Product Name',
                ),
                controller: productNameController,
                onSubmitted: (_) => submitData(),
                     onChanged: (value){
                       this.amountController.text = getAmmount();
                       this.gAPController.text = getGAPAmount();
                     },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Quantity'),
                controller: quantityController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                     onChanged: (value){
                       this.amountController.text = getAmmount();
                       this.gAPController.text = getGAPAmount();
                     },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rate'),
                controller: rateController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                     onChanged: (value){
                       this.amountController.text = getAmmount();
                       this.gAPController.text = getGAPAmount();
                     },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                enabled: false,
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
                decoration: InputDecoration(labelText: 'DP'),
                controller: dPController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                     onChanged: (value){
                       this.amountController.text = getAmmount();
                       this.gAPController.text = getGAPAmount();
                     },
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'GAP'),
                controller: gAPController,
                enabled: false,
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
                  labelText: 'Remarks',
                ),
                controller: remarksController,
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
