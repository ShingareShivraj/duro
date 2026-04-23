import 'package:flutter/material.dart';
import 'package:geolocation/screens/reports/sales_transaction_summary/sales_transaction_summary_screen.dart';
import 'package:geolocation/screens/reports/target_variance_report/target_variance_screen.dart';
import 'package:geolocation/screens/reports/territory_summary/territory_summary_screen.dart';
import 'package:geolocation/screens/reports/leaderboard/leaderboard_screen.dart';

import 'sales_comission_summary/sales_commission_screen.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});

  final List<Report> reports = [
    // Report(
    //   title: 'Sales Person Target Variance',
    //   description: 'Target variance based on item group',
    //   onTap: (context) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => SalesTargetScreen()),
    //     );
    //   },
    // ),
    // Report(
    //   title: 'Sales Person-wise Transaction',
    //   description: 'Transaction summary by sales person',
    //   onTap: (context) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => SalesTransactionSummaryScreen()),
    //     );
    //   },
    // ),
    // Report(
    //   title: 'Sales Person Commission Summary',
    //   description: 'Commission details for sales personnel',
    //   onTap: (context) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => SalesCommissionSummaryScreen()),
    //     );
    //   },
    // ),

    Report(
      title: 'Territory Summary',
      description: 'Rank-wise territory performance (Daily / Monthly / Yearly)',
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TerritorySummaryScreen(),
          ),
        );
      },
    ),

    Report(
      title: 'Sales Leaderboard',
      description: 'Rank wise performance (Sales / Orders / Visits)',
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LeaderboardScreen(),
          ),
        );
      },
    ),

    // Report(
    //   title: 'Sales Summary Report',
    //   description: 'Overall transaction and performance summary',
    //   onTap: () {
    //     debugPrint('Opening Sales Summary Report');
    //   },
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListView.separated(
          itemCount: reports.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final report = reports[index];
            return ReportCard(report: report);
          },
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Report report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => report.onTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.bar_chart,
                    color: theme.colorScheme.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class Report {
  final String title;
  final String description;
  final void Function(BuildContext context) onTap;

  Report({
    required this.title,
    required this.description,
    required this.onTap,
  });
}
