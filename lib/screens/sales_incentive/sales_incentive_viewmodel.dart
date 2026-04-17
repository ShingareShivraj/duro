import 'package:stacked/stacked.dart';
import '../../services/sales_incentive_services.dart';
import '../../model/sales_incentive_model.dart';

class SalesIncentiveViewModel extends BaseViewModel {
  int totalTarget = 1000;
  int totalAchieved = 720;
  int incentiveAmount = 8000;
  double incentiveThreshold = 0.8;
  int bagsToUnlock = 80;
  String selectedPeriod = "monthly";
  final _service = SalesIncentiveServices();

  List<ProductProgress> products = [
    ProductProgress(name: 'Durocon 500', achieved: 320, target: 500),
    ProductProgress(name: 'Durocon 510', achieved: 300, target: 300),
    ProductProgress(name: 'Durocon 520', achieved: 100, target: 200),
  ];

  int get totalPending => totalTarget - totalAchieved;
  double get overallProgress => totalAchieved / totalTarget;

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
      totalTarget = response.totalTarget;
      totalAchieved = response.totalAchieved;
      incentiveAmount = response.incentive;
      products = response.products;
    }

    notifyListeners();
    setBusy(false);
  }
}