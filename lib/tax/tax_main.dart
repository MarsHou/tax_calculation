import 'package:flutter/material.dart';
import 'package:tax_calculation/tax/tax.dart';

class TaxMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new TaxWidget(),
    );
  }
}

class TaxWidget extends StatefulWidget {
  @override
  _TaxState createState() => _TaxState();
}

class _TaxState extends State<TaxWidget> {
  final TextEditingController _controllerIncome = new TextEditingController();
  final TextEditingController _controllerSpecial = new TextEditingController();
  final TextEditingController _controllerYearEndAwards =
      new TextEditingController();
  final TextEditingController _controllerOther = new TextEditingController();
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tax Calculation"),
        backgroundColor: Colors.grey,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildInputRow("税前收入：", _controllerIncome, TextInputType.number),
          _buildInputRow(
              "年终奖：", _controllerYearEndAwards, TextInputType.number),
          _buildInputRow("专项扣除：", _controllerSpecial, TextInputType.number),
          _buildInputRow("其它：", _controllerOther, TextInputType.number),
          new CheckboxListTile(
            title: new Text("是否选择年终奖不计入全年纳税基数"),
            value: this.check,
            onChanged: (bool value) {
              setState(() {
                this.check = !this.check;
              });
            },
          ),
          new RaisedButton(
            onPressed: () {
              double preTaxIncome = 0;
              double specialDeduction = 0;
              double yearEndAwards = 0;
              double other = 0;
              if (_controllerIncome.text.isNotEmpty) {
                preTaxIncome = double.parse(_controllerIncome.text);
              }
              if (_controllerYearEndAwards.text.isNotEmpty) {
                yearEndAwards = double.parse(_controllerYearEndAwards.text);
              }
              if (_controllerSpecial.text.isNotEmpty) {
                specialDeduction = double.parse(_controllerSpecial.text);
              }
              if (_controllerOther.text.isNotEmpty) {
                other = double.parse(_controllerOther.text);
              }
              _calculationTax(
                  preTaxIncome, yearEndAwards, specialDeduction, other);
            },
            child: new Text("计算"),
          )
        ],
      ),
    );
  }

  _calculationTax(double preTaxIncome, double yearEndAwards,
      double specialDeduction, double other) {
    final taxUtil = new TaxUtil();
    final yearModel = taxUtil.getTaxDetailsByPreTaxIncome(
        preTaxIncome, specialDeduction, other, yearEndAwards, 2, this.check);
  }

  _buildInputRow(String title, TextEditingController controller,
      TextInputType keyboardType) {
    return new Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: new TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(labelText: title, hintText: '请输入...'),
        ));
  }
}
