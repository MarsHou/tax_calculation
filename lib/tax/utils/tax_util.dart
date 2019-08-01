import 'package:tax_calculation/tax/model/month_tax_model.dart';
import 'package:tax_calculation/tax/model/tax_model.dart';
import 'package:tax_calculation/tax/model/year_tax_model.dart';

class TaxUtil {
  final medicalRate = 0.02; //医疗
  final endowmentRate = 0.08; //养老
  final unemploymentRate = 0.005; //失业
  final housingRate = 0.07; //公积金
  final allowance = 5000.0; //免税额
  _getMonthTaxOfYearEndAwards() {
    final taxModel0 = TaxModel(0, 0, 3000, 0.03, 0);
    final taxModel1 = TaxModel(1, 3000, 12000, 0.1, 210);
    final taxModel2 = TaxModel(2, 12000, 25000, 0.2, 1410);
    final taxModel3 = TaxModel(3, 25000, 35000, 0.25, 2660);
    final taxModel4 = TaxModel(4, 35000, 55000, 0.3, 4410);
    final taxModel5 = TaxModel(5, 55000, 80000, 0.35, 7160);
    final taxModel6 = TaxModel(6, 80000, 9999999999, 0.45, 15160);
    return [
      taxModel0,
      taxModel1,
      taxModel2,
      taxModel3,
      taxModel4,
      taxModel5,
      taxModel6
    ];
  }

  _getMonthTax() {
    final taxModel0 = TaxModel(0, 0, 36000, 0.03, 0);
    final taxModel1 = TaxModel(1, 36000, 144000, 0.1, 2520);
    final taxModel2 = TaxModel(2, 144000, 300000, 0.2, 16920);
    final taxModel3 = TaxModel(3, 300000, 420000, 0.25, 31920);
    final taxModel4 = TaxModel(4, 420000, 660000, 0.3, 52920);
    final taxModel5 = TaxModel(5, 660000, 960000, 0.35, 85920);
    final taxModel6 = TaxModel(6, 960000, 9999999999, 0.45, 181920);
    return [
      taxModel0,
      taxModel1,
      taxModel2,
      taxModel3,
      taxModel4,
      taxModel5,
      taxModel6
    ];
  }

  getMedicalEndowmentUnemploymentHousingTax(double preTaxIncome) {
    return preTaxIncome *
        (medicalRate + endowmentRate + unemploymentRate + housingRate);
  }

  getTaxDetailsByPreTaxIncome(double preTaxIncome, double specialDeduction,
      double other, double yearEndAwards, int month, bool isOneTime) {
    final meuhIf =
        getMedicalEndowmentUnemploymentHousingTax(preTaxIncome); //需缴三险一金金额

    final payable =
        (preTaxIncome - allowance - meuhIf - specialDeduction); //应纳税额

    double allPayable = 0; //累计应纳税额
    double allPayableTax = 0; //累计缴税额
    double allRealIncome = 0; //累计实发工资
    List<MonthTaxModel> listMonth = new List();
    for (int i = 1; i <= 12; i++) {
      List<TaxModel> modelList = _getMonthTax();
      TaxModel taxModel;
      if (payable > 0) {
        allPayable += payable;
      }
      if (i == month && !isOneTime) {
        allPayable += yearEndAwards;
      }
      for (var item in modelList) {
        if (allPayable > item.startLimit && allPayable <= item.endStartLimit) {
          taxModel = item;
          break;
        }
      }
      double payableTax = 0.0;
      if (taxModel != null) {
        payableTax =
            allPayable * taxModel.taxRate - taxModel.deduction - allPayableTax;
      }
      allPayableTax += payableTax;
      double realIncome = preTaxIncome - meuhIf - payableTax - other;
      if (i == month && !isOneTime) {
        realIncome += yearEndAwards;
      }
      allRealIncome += realIncome;
      print(
          "$i 月纳税基数：$allPayable 纳税：$payableTax ; 三险一金：${meuhIf.toStringAsFixed(1)}; 其它费用：$other ; 实发工资：$realIncome");
      listMonth.add(new MonthTaxModel(
          i, allPayable, payableTax, meuhIf, other, realIncome));
    }
    double realyearEndAwards = 0;
    double yeaPayableTax = 0;
    if (yearEndAwards > 0 && isOneTime) {
      List<TaxModel> methodTaxGradeList = _getMonthTaxOfYearEndAwards();
      double money = yearEndAwards / 12;
      for (TaxModel tax in methodTaxGradeList) {
        if (money > tax.startLimit && money <= tax.endStartLimit) {
          //找到对应的纳税等级
          yeaPayableTax = (yearEndAwards * tax.taxRate) - tax.deduction;
          break;
        }
      }
      realyearEndAwards = yearEndAwards - yeaPayableTax;
      print("全年一次性奖金计算 纳税：$yeaPayableTax ；年终奖实发：$realyearEndAwards");
    }
    allPayableTax += yeaPayableTax;
    allRealIncome += realyearEndAwards;
    print('累计纳税：$allPayableTax ; 累计实发工资：$allRealIncome');
    return YearTaxModel(listMonth, allPayableTax, allRealIncome,
        realyearEndAwards, yeaPayableTax);
  }
}
