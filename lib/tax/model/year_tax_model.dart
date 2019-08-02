import 'package:tax_calculation/tax/tax.dart';

class YearTaxModel {
  List<MonthTaxModel> listMonth;
  double preTaxIncome;
  double allPayableTax;
  double allRealIncome;
  double yeaRealIncome;
  double yeaPayableTax;
  YearTaxModel(this.listMonth, this.preTaxIncome, this.allPayableTax,
      this.allRealIncome, this.yeaRealIncome, this.yeaPayableTax);
}
