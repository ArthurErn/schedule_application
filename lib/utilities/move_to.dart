import 'package:flutter/material.dart';

class MoveTo{

  page(context, Widget page){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
  }

  pageAndReplace(context, Widget page){
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
  }
}