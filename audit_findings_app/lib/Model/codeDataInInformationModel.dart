
import 'package:flutter/material.dart';

class CodeDataMode{
  final String customerCode;
  final String customerName;
  final String creditLimit;
  final String creditDays;
  final String moMSOName;
  final String aEAMName;
  final String zSMRSMName;
  final String sMName;
  final String aaddress;
  final String contactNumber;
  final String asPerACI;
  final String smsDue;
  String totalDue;
  String overDue;
  String overDue120;
  String age;
  String creditType;
  CodeDataMode({this.customerCode,this.customerName,this.creditLimit,this.creditDays,this.moMSOName,this.aEAMName,this.zSMRSMName,this.sMName, this.aaddress,this.contactNumber,this.asPerACI,this.smsDue,
  this.totalDue,this.overDue,this.overDue120,this.age, this.creditType
  });

}