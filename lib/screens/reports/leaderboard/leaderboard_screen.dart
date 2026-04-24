import 'package:flutter/material.dart';
import 'package:geolocation/screens/reports/leaderboard/leaderboard_viewmodel.dart';
import 'package:geolocation/widgets/period_filter_chip.dart';
import 'package:stacked/stacked.dart';


class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaderboardViewModel>.reactive(
      viewModelBuilder: () => LeaderboardViewModel(),
      onViewModelReady: (vm) {
        final String? period =
        ModalRoute.of(context)?.settings.arguments as String?;
        vm.initialize(period);
      },
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Sales Leaderboard"),
            actions: [
              Row(
                children: [
                  PeriodFilterChip(
                    period: "Daily",
                    selectedPeriod: vm.selectedPeriod,
                    onSelected: vm.changePeriod,
                  ),
                  PeriodFilterChip(
                    period: "Monthly",
                    selectedPeriod: vm.selectedPeriod,
                    onSelected: vm.changePeriod,
                  ),
                  PeriodFilterChip(
                    period: "Yearly",
                    selectedPeriod: vm.selectedPeriod,
                    onSelected: vm.changePeriod,
                  ),
                ],
              )
            ],
          ),

          // 🔥 BODY
          // body: vm.isBusy
          //     ? const Center(child: CircularProgressIndicator())
          //     : vm.data.isEmpty
          //     ? const Center(child: Text("No data found"))
          //     : ListView.builder(
          //   padding: const EdgeInsets.all(10),
          //   itemCount: vm.data.length,
          //   itemBuilder: (context, index) {
          //     final item = vm.data[index];
          //
          //     return Card(
          //       elevation: 3,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       margin: const EdgeInsets.symmetric(vertical: 6),
          //       child: ListTile(
          //         leading: CircleAvatar(
          //           backgroundColor: Colors.blue.shade100,
          //           child: Text(
          //             "#${index + 1}",
          //             style: const TextStyle(
          //                 fontWeight: FontWeight.bold),
          //           ),
          //         ),
          //         title: Text(
          //           item.salesPerson,
          //           style:
          //           const TextStyle(fontWeight: FontWeight.w600),
          //         ),
          //         subtitle: Text(
          //           "Orders: ${item.orders}  |  Visits: ${item.visits}",
          //         ),
          //         trailing: Text(
          //           item.totalSales.toStringAsFixed(0),
          //           style: const TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),


          body: vm.isBusy
              ? const Center(child: CircularProgressIndicator())
              : vm.data.isEmpty
              ? const Center(child: Text("No data found"))
              : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Rank")),
                  DataColumn(label: Text("Sales Person")),
                  DataColumn(label: Text("Total Sales")),
                  DataColumn(label: Text("Orders")),
                  DataColumn(label: Text("Visits")),
                ],
                rows: vm.data.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.rank.toString())),
                    DataCell(Text(item.salesPerson)),
                    DataCell(Text(item.totalSales.toStringAsFixed(0))),
                    DataCell(Text(item.orders.toString())),
                    DataCell(Text(item.visits.toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}