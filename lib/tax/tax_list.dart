
import 'package:flutter/material.dart';
import 'package:tax_calculation/tax/model/year_tax_model.dart';

class TaxList extends StatelessWidget{
  YearTaxModel yearModel;
  TaxList(this.yearModel);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text('Tax List'),
        ),
      ),
    );
  }
}