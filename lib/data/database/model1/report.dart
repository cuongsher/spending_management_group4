class BarEntry {
  final String label;
  final int income;
  final int expense;
  const BarEntry({required this.label, required this.income, required this.expense});
}

class CategoryEntry {
  final String category;
  final int amount;
  const CategoryEntry({required this.category, required this.amount});
}

class ReportSummary {
  final int totalIncome;
  final int totalExpense;
  final List<BarEntry> barEntries;
  final List<CategoryEntry> categoryEntries;

  const ReportSummary({
    required this.totalIncome,
    required this.totalExpense,
    this.barEntries = const [],
    this.categoryEntries = const [],
  });

  int get balance => totalIncome - totalExpense;
}
