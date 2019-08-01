class TaxModel {
  int grade; //税率等级
  int startLimit; //开始限额
  int endStartLimit; //结算限额
  double taxRate; //税率
  int deduction; //速算扣除数
  
  TaxModel(this.grade, this.startLimit, this.endStartLimit, this.taxRate,
      this.deduction);
}
