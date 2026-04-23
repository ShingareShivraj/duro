import 'package:geolocation/model/territory_summary_model.dart';
import 'package:geolocation/services/report_services.dart';
import 'package:stacked/stacked.dart';

class TerritorySummaryViewModel extends BaseViewModel {
  List<TerritorySummary> data = [];
  String selectedPeriod = "Yearly";

  Future<void> initialize() async {
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