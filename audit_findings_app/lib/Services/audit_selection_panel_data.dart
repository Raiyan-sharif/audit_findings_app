
import 'dart:io';

import 'package:flutter/material.dart';


class AuditData{
  final List<WrongPaymentData> wrongPaymentDataList = [];
  final List<PaymentMadeNotDepositedData> paymentMadeNotDepositedDataList = [];
  final List<InvoiceRaisedNotReceived> invoiceRaisedNotReceivedList = [];
  final List<ShiftedToSD> shiftedToSDList = [];
  final List<StockWithFF> stockWithFFList = [];
  final List<ProductReceived> productReceivedList = [];
  final List<ProductReceivedOthers> productReceivedOthersList = [];
  final List<PendingIncentiveClaim> pendingIncentiveClaimList = [];
  final List<UnderrateProductSold> underrateProductSoldList = [];
  final List<BusinessWithACIModel> businessWithACIModelList = [];
  final List<CustomerRecoveryCommitment> customerRecoveryCommitmentList = [];
  final List<MORecoveryCommitment> mORecoveryCommitmentList = [];
  final List<RSMRecoveryCommitment> rSMRecoveryCommitmentList = [];

  static var Owninstance = AuditData();
}
class WrongPaymentData{
  String id;
  String customerInfoId;
  DateTime date;
  double amount;
  String code;
  String tMR;
  File image;
  WrongPaymentData({this.id,this.customerInfoId,this.date,this.amount,this.code,this.tMR,this.image});
}
class PaymentMadeNotDepositedData{
  String id;
  String customerInfoId;
  String invoice;
  String quantity;
  DateTime date;
  double amount;
  String code;
  File image;
  PaymentMadeNotDepositedData({this.id, this.customerInfoId,this.invoice,this.quantity,this.date,this.amount,this.code,this.image});
}
class InvoiceRaisedNotReceived{
  String id;
  String customerInfoId;
  DateTime date;
  double amount;
  String invoice;
  String depositConfirmation;
  InvoiceRaisedNotReceived({this.id,this.customerInfoId, this.date, this.amount, this.invoice, this.depositConfirmation});
}
class ShiftedToSD{
  String id;
  String customerInfoId;
  String invoice;
  DateTime date;
  double amount;
  int quantity;
  String code;
  String customerName;
  String address;
  ShiftedToSD({this.id,this.customerInfoId,this.invoice,this.date,this.amount, this.quantity, this.code,this.customerName,this.address});
}

class StockWithFF{
  String id;
  String customerInfoId;
  String invoice;
  DateTime date;
  String quantity;
  double amount;
  String ffName;
  String noOfWareHouse;
  String address;
  File image;
  StockWithFF({this.id,this.customerInfoId,this.invoice,this.date,this.quantity,this.amount,this.ffName,this.noOfWareHouse,this.address,this.image});
}
class ProductReceived{
  String id;
  String customerInfoId;
  String invoice;
  double amount;
  int quantity;
  String code;
  String customerName;
  String address;
  DateTime date;
  File image;
  ProductReceived({this.id,this.customerInfoId,this.invoice,this.amount,this.quantity,this.code, this.customerName,this.address,this.date,this.image});
}
class ProductReceivedOthers{
  String id;
  String customerInfoId;
  String invoice;
  double amount;
  int quantity;
  String code;
  String customerName;
  String address;
  DateTime date;
  ProductReceivedOthers({this.id,this.customerInfoId,this.invoice,this.amount,this.quantity,this.code,this.customerName,this.address,this.date});
}
class PendingIncentiveClaim{
  String id;
  String customerInfoId;
  String remarks;
  double amount;
  File image;
  PendingIncentiveClaim({this.id,this.customerInfoId,this.remarks,this.amount,this.image});
}
class UnderrateProductSold{
  String id;
  String customerInfoId;
  String remarks;
  double amount;
  String productName;
  String quality;
  String rate;
  String dP;
  String gAP;
  File image;
  UnderrateProductSold({this.id,this.customerInfoId,this.remarks,this.amount,this.productName,this.quality,this.rate,this.dP,this.gAP,this.image});
}
class OtherObservations{
  String id;
  String customerInfoId;
  List<OtherObservationItem> observations;
  OtherObservations({this.id,this.customerInfoId,this.observations});

  Map toJson() {
    List<Map> observations = this.observations == null ? null : this
        .observations.map((e) => e.toJson()).toList();
    return { "id": id,
      "customerInfoId": customerInfoId,
      "observations": observations,

    };
  }
}
class OtherObservationItem with ChangeNotifier{
  String description;
  bool isChecked;
  OtherObservationItem({this.description,this.isChecked});

  OtherObservationItem.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        isChecked = json['isChecked'];

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'isChecked': isChecked,
    };
  }
}

class BusinessWithACIModel{
  String id;
  String customerId;
  String code;
  String customerName;
  int totalDue;
  int overDue;
  int overDue120;
  int age;
  String creditType;
  BusinessWithACIModel({this.id,this.customerId,this.code,this.customerName,this.totalDue,this.overDue,this.overDue120,this.age,this.creditType});
}

class CustomerRecoveryCommitment{
  String id;
  String customerInfoId;
  DateTime date;
  int amount;
  CustomerRecoveryCommitment({this.id,this.customerInfoId,this.date,this.amount});
}
//MORecoveryCommitment
class MORecoveryCommitment{
  String id;
  String customerInfoId;
  DateTime date;
  int amount;
  MORecoveryCommitment({this.id,this.customerInfoId,this.date,this.amount});
}

class RSMRecoveryCommitment{
  String id;
  String customerInfoId;
  DateTime date;
  int amount;
  File fileData;
  File attachment;
  RSMRecoveryCommitment({this.id,this.customerInfoId,this.date,this.amount,this.fileData,this.attachment});
}