import 'package:stacked/stacked.dart';
import 'package:geolocation/model/territory_summary_model.dart';
import 'package:geolocation/services/report_services.dart';

class TerritorySummaryViewModel extends BaseViewModel {
  List<TerritorySummary> data = [];

  String selectedPeriod = "Monthly";

  Future<void> initialize([String? period]) async {
    if (period != null) {
      selectedPeriod = period;
    }

    await fetchData();
  }

  Future<void> fetchData() async {
    setBusy(true);

    data = await ReportServices().fetchTerritorySummary(selectedPeriod);

    setBusy(false);
    notifyListeners();
  }

  void changePeriod(String period) async {
    selectedPeriod = period;
    await fetchData();
  }
}