import 'package:geolocation/model/leaderboard_model.dart';
import 'package:geolocation/services/report_services.dart';
import 'package:stacked/stacked.dart';

class LeaderboardViewModel extends BaseViewModel {
  List<LeaderboardModel> data = [];

  /// Default period (used when screen opened directly)
  String selectedPeriod = "Monthly";

  /// 🔥 Initialize (handles both cases: with/without period)
  Future<void> initialize([String? period]) async {
    if (period != null && period.isNotEmpty) {
      selectedPeriod = period;
    }

    await fetchData();
  }

  /// 🔥 Fetch data from API
  Future<void> fetchData() async {
    setBusy(true);

    try {
      final result =
      await ReportServices().fetchLeaderboard(selectedPeriod);

      data = result ?? [];
    } catch (e) {
      data = [];
    }

    setBusy(false);
    notifyListeners();
  }

  /// 🔥 Change period from UI
  void changePeriod(String period) async {
    if (selectedPeriod == period) return; // avoid duplicate API call

    selectedPeriod = period;
    await fetchData();
  }
}