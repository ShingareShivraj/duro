import 'package:flutter/material.dart';
import 'package:geolocation/screens/reports/territory_summary/territory_summary_viewmodel.dart';
import 'package:geolocation/widgets/full_screen_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:geolocation/widgets/period_filter_chip.dart';

class TerritorySummaryScreen extends StatelessWidget {
  const TerritorySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TerritorySummaryViewModel>.reactive(
      viewModelBuilder: () => TerritorySummaryViewModel(),
      onViewModelReady: (vm) => vm.initialize(),
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Territory Summary"),
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
          body: fullScreenLoader(
            context: context,
            loader: vm.isBusy,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Rank")),
                  DataColumn(label: Text("Territory")),
                  DataColumn(label: Text("Active")),
                  DataColumn(label: Text("Non Active")),
                  DataColumn(label: Text("New")),
                  DataColumn(label: Text("Converted")),
                  DataColumn(label: Text("Leads")),
                ],
                rows: vm.data.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.rank.toString())),
                    DataCell(Text(item.territory)),
                    DataCell(Text(item.active.toString())),
                    DataCell(Text(item.nonActive.toString())),
                    DataCell(Text(item.newCustomers.toString())),
                    DataCell(Text(item.converted.toString())),
                    DataCell(Text(item.leads.toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(
      TerritorySummaryViewModel vm, String period) {
    return TextButton(
      onPressed: () => vm.changePeriod(period),
      child: Text(
        period,
        style: TextStyle(
          color: vm.selectedPeriod == period
              ? Colors.yellow
              : Colors.white,
        ),
      ),
    );
  }
}