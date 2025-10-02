import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/blood_sugar_entry.dart';
import '../database/database_helper.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<BloodSugarEntry> _entries = [];
  List<BloodSugarEntry> _fastingEntries = [];
  List<BloodSugarEntry> _nonFastingEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final entries = await _db.getEntriesLastMonths(3);
    if (!mounted) return;
    
    setState(() {
      _entries = entries;
      _fastingEntries = entries.where((e) => e.isFasting).toList();
      _nonFastingEntries = entries.where((e) => !e.isFasting).toList();
      _isLoading = false;
    });
  }

  List<FlSpot> _getFastingSpots() {
    return List.generate(
      _fastingEntries.length,
      (index) => FlSpot(
        index.toDouble(),
        _fastingEntries[index].bloodSugar,
      ),
    );
  }

  List<FlSpot> _getNonFastingSpots() {
    return List.generate(
      _nonFastingEntries.length,
      (index) => FlSpot(
        index.toDouble(),
        _nonFastingEntries[index].bloodSugar,
      ),
    );
  }

  Widget _buildChart({
    required String title,
    required List<FlSpot> spots,
    required Color color,
    required List<BloodSugarEntry> entries,
  }) {
    if (spots.isEmpty) {
      return Card(
        elevation: 3,
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 15),
                Text(
                  'داده‌ای برای نمایش وجود ندارد',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= entries.length) {
                            return const Text('');
                          }
                          final entry = entries[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${entry.month}/${entry.day}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  minX: 0,
                  maxX: (spots.length - 1).toDouble(),
                  minY: () {
                    final minValue = _calculateMin(entries);
                    final maxValue = _calculateMax(entries);
                    final padding = (maxValue - minValue) * 0.1;
                    return (minValue - padding).clamp(0.0, double.infinity);
                  }(),
                  maxY: () {
                    final minValue = _calculateMin(entries);
                    final maxValue = _calculateMax(entries);
                    final padding = (maxValue - minValue) * 0.1;
                    return maxValue + padding;
                  }(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: color,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          if (index < 0 || index >= entries.length) {
                            return null;
                          }
                          final entry = entries[index];
                          return LineTooltipItem(
                            '${entry.getFormattedDate()}\n${spot.y.toInt()} mg/dL',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  'میانگین',
                  _calculateAverage(entries).toStringAsFixed(1),
                  Icons.functions,
                  Colors.blue,
                ),
                _buildStat(
                  'بیشترین',
                  _calculateMax(entries).toStringAsFixed(0),
                  Icons.arrow_upward,
                  Colors.red,
                ),
                _buildStat(
                  'کمترین',
                  _calculateMin(entries).toStringAsFixed(0),
                  Icons.arrow_downward,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  double _calculateAverage(List<BloodSugarEntry> entries) {
    if (entries.isEmpty) return 0;
    final sum = entries.fold<double>(0.0, (sum, entry) => sum + entry.bloodSugar);
    return sum / entries.length;
  }

  double _calculateMax(List<BloodSugarEntry> entries) {
    if (entries.isEmpty) return 0;
    return entries.map((e) => e.bloodSugar).reduce((a, b) => a > b ? a : b);
  }

  double _calculateMin(List<BloodSugarEntry> entries) {
    if (entries.isEmpty) return 0;
    return entries.map((e) => e.bloodSugar).reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),
            // Header
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.analytics,
                      size: 40,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'نمودار قند خون - ۳ ماه گذشته',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'تعداد کل ثبت‌ها: ${_entries.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Fasting Chart
            _buildChart(
              title: 'نمودار قند خون ناشتا 🌅',
              spots: _getFastingSpots(),
              color: Colors.blue,
              entries: _fastingEntries,
            ),
            const SizedBox(height: 20),
            // Non-Fasting Chart
            _buildChart(
              title: 'نمودار قند خون غیر ناشتا 🍽️',
              spots: _getNonFastingSpots(),
              color: Colors.orange,
              entries: _nonFastingEntries,
            ),
            const SizedBox(height: 20),
            // Reference Card
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'مقادیر مرجع',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    const Text(
                      '✓ قند خون طبیعی ناشتا: 70-100 mg/dL',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '✓ قند خون طبیعی غیر ناشتا: کمتر از 140 mg/dL',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '✓ پیش دیابت ناشتا: 100-125 mg/dL',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '✓ دیابت: بیش از 126 mg/dL (ناشتا)',
                      style: TextStyle(fontSize: 14),
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
}
