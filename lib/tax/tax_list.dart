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
      padding: const EdgeInsets.all(10),
      itemCount: listMonth.length,
      itemBuilder: (context, i) {
        return _buildListItem(listMonth[i]);
      },
      separatorBuilder: (context, i) => const Divider(),
    );
  }

  _buildListItem(MonthTaxModel model) {
    final tableRaw = <TableRow>[];
    tableRaw.add(_buildTableRow("月       份：", model.month.toString(), "实发工资：",
        model.realIncome.toStringAsFixed(1)));
    tableRaw.add(_buildTableRow("纳税基数：", model.allPayable.toStringAsFixed(1),
        "纳  税  额：", model.payableTax.toStringAsFixed(1)));
    tableRaw.add(_buildTableRow("公  积  金：", model.meuhIf[3].toStringAsFixed(1),
        "医疗保险：", model.meuhIf[0].toStringAsFixed(1)));
    tableRaw.add(_buildTableRow("养老保险：", model.meuhIf[1].toStringAsFixed(1),
        "失业保险：", model.meuhIf[2].toStringAsFixed(1)));
    if (model.other > 0) {
      tableRaw
          .add(_buildTableRow("其它费用：", model.other.toStringAsFixed(1), "", ""));
    }
    return Table(
      children: tableRaw,
    );
  }

  _buildTableRow(String title1, String val1, String title2, String val2,
      [double fontSize = 15]) {
    return TableRow(children: <Widget>[
      _buildRichText(title1, val1, fontSize),
      _buildRichText(title2, val2, fontSize)
    ]);
  }

  _buildHeaderTableRow(String title, String val, [double fontSize = 15]) {
    return TableRow(children: <Widget>[_buildRichText(title, val, fontSize)]);
  }

  _buildHeaderView(YearTaxModel yearModel) {
    final widgets = <TableRow>[];
    widgets.add(_buildHeaderTableRow(
        "税 前 月 薪：", yearModel.preTaxIncome.toStringAsFixed(1), 17));
    widgets.add(_buildHeaderTableRow(
        "累 计 纳 税：", yearModel.allPayableTax.toStringAsFixed(1), 17));
    widgets.add(_buildHeaderTableRow(
        "累 计 实 发：", yearModel.allRealIncome.toStringAsFixed(1), 17));
    if (yearModel.yeaRealIncome != null && yearModel.yeaRealIncome > 0) {
      widgets.add(_buildHeaderTableRow(
          "年终奖纳税：", yearModel.yeaPayableTax.toStringAsFixed(1), 17));
      widgets.add(_buildHeaderTableRow(
          "年终奖实发：", yearModel.yeaRealIncome.toStringAsFixed(1), 17));
    }
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
      child: Table(
        children: widgets,
      ),
    );
  }

  _buildRichText(String title, String val, [double fontSize = 15]) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: RichText(
          text: TextSpan(
            text: "",
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: '$title',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: Colors.black54)),
              TextSpan(
                  text: '$val',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: Colors.green))
            ],
          ),
        ));
  }
}
