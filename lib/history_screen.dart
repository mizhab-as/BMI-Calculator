import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:trial1/bmi_record.dart';
import 'package:trial1/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<BmiRecord> _records = [];
  bool _isLoading = true;
  bool _showWeightTrend = true; // true = Weight, false = BMI

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    final records = await StorageService.getRecords();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  Future<void> _deleteRecord(String id) async {
    await StorageService.deleteRecord(id);
    _loadRecords();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Record deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History?'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.clearAll();
      _loadRecords();
    }
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.cyan;
    if (bmi < 25.0) return Colors.emerald;
    if (bmi < 30.0) return Colors.orange;
    return Colors.redAccent;
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Healthy';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate stats
    double weightChange = 0.0;
    double currentWeight = 0.0;
    double startingWeight = 0.0;

    if (_records.isNotEmpty) {
      currentWeight = _records.first.weight;
      startingWeight = _records.last.weight;
      weightChange = currentWeight - startingWeight;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health History'),
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear All',
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? _buildEmptyState(theme, isDark)
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  children: [
                    // Stats Summary Card
                    _buildStatsCard(theme, currentWeight, startingWeight, weightChange),
                    const SizedBox(height: 20),

                    // Trend Graph Section
                    if (_records.length >= 2) ...[
                      _buildGraphSection(theme),
                      const SizedBox(height: 25),
                    ],

                    // History Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Entries',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Swipe item to delete',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // List of logs
                    ..._records.map((record) => _buildRecordTile(record, theme, isDark)),
                  ],
                ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(0.08),
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 50,
                color: theme.colorScheme.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No History Yet',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Your calculated BMI reports and body logs will appear here. Calculate your first BMI report to begin tracking!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.add),
              label: const Text('Calculate BMI Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, double current, double starting, double change) {
    final changeText = change == 0.0
        ? 'No change'
        : change > 0
            ? '+${change.toStringAsFixed(1)} kg'
            : '${change.toStringAsFixed(1)} kg';
    final changeColor = change == 0.0
        ? Colors.grey
        : change > 0
            ? Colors.orange
            : Colors.emerald;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight Change',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      changeText,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.black,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    change >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: changeColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 25, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatSubItem(theme, 'Start', '${starting.toStringAsFixed(1)} kg'),
                _buildStatSubItem(theme, 'Current', '${current.toStringAsFixed(1)} kg'),
                _buildStatSubItem(theme, 'Target Range', '18.5 - 24.9 BMI'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSubItem(ThemeData theme, String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildGraphSection(ThemeData theme) {
    // Reverse records to draw chart chronologically (oldest to newest)
    final chronRecords = _records.reversed.toList();

    // Map records to chart spots
    final List<FlSpot> spots = [];
    for (int i = 0; i < chronRecords.length; i++) {
      final val = _showWeightTrend ? chronRecords[i].weight : chronRecords[i].bmi;
      spots.add(FlSpot(i.toDouble(), val));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 20, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    _showWeightTrend ? 'Weight Trend' : 'BMI Trend',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                // Toggle Button
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Weight'),
                      selected: _showWeightTrend,
                      onSelected: (val) {
                        if (val) setState(() => _showWeightTrend = true);
                      },
                      labelStyle: TextStyle(fontSize: 12, color: _showWeightTrend ? Colors.white : null),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('BMI'),
                      selected: !_showWeightTrend,
                      onSelected: (val) {
                        if (val) setState(() => _showWeightTrend = false);
                      },
                      labelStyle: TextStyle(fontSize: 12, color: !_showWeightTrend ? Colors.white : null),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 5,
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withOpacity(0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTile(BmiRecord record, ThemeData theme, bool isDark) {
    final formattedDate = DateFormat('MMM dd, yyyy • h:mm a').format(record.date);
    final statusColor = _getBmiColor(record.bmi);

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (direction) => _deleteRecord(record.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Circle status code
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    record.bmi.toStringAsFixed(1),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 16,
                      fontWeight: FontWeight.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Weight details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${record.weight.toStringAsFixed(1)} kg',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|  ${record.height.toInt()} cm',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.solid(color: statusColor.withOpacity(0.2), width: 1),
                ),
                child: Text(
                  _getBmiCategory(record.bmi),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
