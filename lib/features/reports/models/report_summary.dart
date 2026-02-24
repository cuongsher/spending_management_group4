class ReportSummary {
  final int totalIncome;
  final int totalExpense;

  const ReportSummary({
    required this.totalIncome,
    required this.totalExpense,
  });

  int get balance => totalIncome - totalExpense;
}