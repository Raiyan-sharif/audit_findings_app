import 'package:flutter/foundation.dart';
class WrongPaymentModel {
  final DateTime date;
  final double amount;
  final String code;
  final String tmr;
  final String id;
  WrongPaymentModel({
    @required this.id,
    @required this.code,
    @required this.tmr,
    @required this.amount,
    @required this.date,
  });

}