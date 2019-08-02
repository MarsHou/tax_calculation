import 'package:flutter/material.dart';
import 'package:tax_calculation/tax/tax.dart';

class TaxList extends StatelessWidget {
  final YearTaxModel yearModel;
  TaxList(this.yearModel);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.grey,
          title: Text('全年纳税详情'),
        ),
        body: TaxListStatefulWidget(this.yearModel),
      ),
    );
  }
}

class TaxListStatefulWidget extends StatefulWidget {
  final YearTaxModel yearModel;
  TaxListStatefulWidget(this.yearModel);
  @override
  TaxListState createState() {
    return TaxListState(this.yearModel);
  }
}

class TaxListState extends State<StatefulWidget> {
  YearTaxModel yearModel;
  TaxListState(this.yearModel);
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        _buildHeaderView(yearModel),
        Expanded(
          child: _buildListView(yearModel.listMonth),
        )
      ],
    );
  }

  _buildListView(List<MonthTaxModel> listMonth) {
    debugPrint(listMonth.length.toString());
    return ListView.separated(
      padding: const EdgeInsets.only(top: 40,left: 10,right: 10),
      itemCount: listMonth.length,
      itemBuilder: (context, i) {
        return _buildListItem(listMonth[i]);
      },
      separatorBuilder: (context, i) => const Divider(),
    );
  }

  _buildListItem(MonthTaxModel model) {
    return Table(
      children: <TableRow>[
        _buildTableRow("月       份", model.month.toString(), "实发工资",
            model.realIncome.toStringAsFixed(2)),
        _buildTableRow("纳税基数", model.allPayable.toStringAsFixed(2), "纳  税  额",
            model.payableTax.toStringAsFixed(2)),
            _buildTableRow("公  积  金", model.meuhIf[3].toStringAsFixed(2), "医疗保险",
            model.meuhIf[0].toStringAsFixed(2)),
            _buildTableRow("养老保险", model.meuhIf[1].toStringAsFixed(2), "失业保险",
            model.meuhIf[2].toStringAsFixed(2))
      ],
    );
  }

  _buildTableRow(String title1, String val1, String title2, String val2) {
    return TableRow(children: <Widget>[
      _buildRichText(title1, val1),
      _buildRichText(title2, val2)
    ]);
  }

  _buildHeaderView(YearTaxModel yearModel) {
    final widgets = <Widget>[];
    widgets.add(_buildHeaderItem(
        "累计纳税",
        yearModel.allPayableTax.toStringAsFixed(2),
        "累计实发",
        yearModel.allRealIncome.toStringAsFixed(2)));
    if (yearModel.yeaRealIncome != null && yearModel.yeaRealIncome > 0) {
      widgets.add(_buildHeaderItem(
          "年终奖纳税",
          yearModel.yeaPayableTax.toStringAsFixed(2),
          "年终奖实发",
          yearModel.yeaRealIncome.toStringAsFixed(2)));
    }
    return Column(
      children: widgets,
    );
  }

  _buildHeaderItem(String title1, String val1, String title2, String val2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRichText(title1, val1),
        _buildRichText(title2, val2)
      ],
    );
  }

  _buildRichText(String title, String val) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: RichText(
          text: TextSpan(
            text: "",
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: '$title:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black54)),
              TextSpan(
                  text: ' $val',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.green))
            ],
          ),
        ));
  }
}
