import 'package:geolocation/model/leaderboard_model.dart';
import 'package:geolocation/services/report_services.dart';
import 'package:stacked/stacked.dart';

class LeaderboardViewModel extends BaseViewModel {
  List<LeaderboardModel> data = [];
  String selectedPeriod = "Monthly";

  Future<void> initialize() async {
    await fetchData();
  }

  Future<void> fetchData() async {
    setBusy(true);
    data = await ReportServices().fetchLeaderboard(selectedPeriod);
    setBusy(false);
    notifyListeners();
  }

  void changePeriod(String period) async {
    selectedPeriod = period;
    await fetchData();
  }
}