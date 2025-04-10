import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:schools/config/routing.dart';
import 'package:schools/details.dart';
import 'package:schools/shared_components/colors.dart';
import 'package:schools/shared_components/style.dart';
import 'package:schools/welcome.dart';



class home_sc extends StatefulWidget {
  const home_sc({ Key? key }) : super(key: key);

  @override
  State<home_sc> createState() => _home_scState();
}

class _home_scState extends State<home_sc> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}