import 'package:flutter/material.dart';
import 'package:tax_calculation/tax/tax.dart';

class TaxMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  double month = 1;
  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    widgets
        .add(_buildInputRow("税前收入：", _controllerIncome, TextInputType.number));
    widgets.add(
        _buildInputRow("年终奖：", _controllerYearEndAwards, TextInputType.number));
    if (!this.check) {
      widgets.add(new Container(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: new Row(
            children: <Widget>[
              Text("奖金发放月份（${this.month.toInt()}月）："),
              Expanded(
                child: new Slider(
                  value: this.month,
                  divisions: 11,
                  max: 12,
                  min: 1,
                  label: "${this.month.toInt()}",
                  activeColor: Colors.blue,
                  onChanged: (double val) {
                    setState(() {
                      this.month = val;
                    });
                  },
                ),
              )
            ],
          )));
    }
    widgets
        .add(_buildInputRow("专项扣除：", _controllerSpecial, TextInputType.number));
    widgets.add(_buildInputRow("其它：", _controllerOther, TextInputType.number));
    widgets.add(new CheckboxListTile(
      title: new Text(
        "是否选择年终奖不计入全年纳税基数",
        style: TextStyle(color: Colors.blue),
      ),
      value: this.check,
      onChanged: (bool value) {
        setState(() {
          this.check = !this.check;
        });
      },
    ));
    widgets.add(new RaisedButton(
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
            context, preTaxIncome, yearEndAwards, specialDeduction, other);
      },
      child: new Text(
        "计算",
        style: TextStyle(color: Colors.blue),
      ),
    ));

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("个税计算器"),
        backgroundColor: Colors.grey,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  _calculationTax(BuildContext context, double preTaxIncome,
      double yearEndAwards, double specialDeduction, double other) {
    final taxUtil = new TaxUtil();
    final yearModel = taxUtil.getTaxDetailsByPreTaxIncome(preTaxIncome,
        specialDeduction, other, yearEndAwards, this.month.toInt(), this.check);
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new TaxList(yearModel)));
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
