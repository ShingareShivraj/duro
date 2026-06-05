import 'package:stacked/stacked.dart';
import '../../services/sales_incentive_services.dart';
import '../../model/sales_incentive_model.dart';

class SalesIncentiveViewModel extends BaseViewModel {
  int totalTarget = 1000;
  int totalAchieved = 720;
  double incentiveAmount = 0;

  String selectedPeriod = "monthly";
  String monthLabel = "Month";
  String fyLabel = "FY";
  final _service = SalesIncentiveServices();

  List<ProductProgress> products = [];

  int get totalPending => totalTarget - totalAchieved;
  double get overallProgress =>
      totalTarget == 0 ? 0 : totalAchieved / totalTarget;

  Future<void> initialise() async {
    setBusy(true);
    await fetchData();
    setBusy(false);
  }

  Future<void> refresh() async {
    await initialise();
  }

  void setPeriod(String value) {
    selectedPeriod = value;
    fetchData();
  }

  Future<void> fetchData() async {
    setBusy(true);

    final response = await _service.fetchSalesIncentive(selectedPeriod);

    if (response != null) {
      print("MONTH = ${response.monthLabel}");
      print("FY = ${response.fyLabel}");
      totalTarget = response.totalTarget;
      totalAchieved = response.totalAchieved;
      incentiveAmount = response.incentive;
      products = response.products;

      monthLabel = response.monthLabel;
      fyLabel = response.fyLabel;
    }

    notifyListeners();
    setBusy(false);
  }
}