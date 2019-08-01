import 'package:tax_calculation/tax/tax.dart';

class YearTaxModel {
  List<MonthTaxModel> listMonth;
  double allPayableTax;
  double allRealIncome;
  double yearEndAwards;
  double yeaPayableTax;
  YearTaxModel(this.listMonth, this.allPayableTax, this.allRealIncome,
      this.yearEndAwards, this.yeaPayableTax);
}
