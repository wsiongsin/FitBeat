import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import './start_screen.dart';
import 'package:fitbeat/main.dart';

// Enum to identify widget types
enum DashboardWidgetType {
  workoutSummary,
  strengthProgress,
  weeklyVolume,
}

// Widget wrapper to track type and enable removal
class DashboardWidget extends StatelessWidget {
  final DashboardWidgetType type;
  final Widget child;
  final VoidCallback onRemove;

  const DashboardWidget({
    required this.type,
    required this.child,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 8,
          right: 8,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              color: CupertinoColors.systemGrey,
              size: 24,
            ),
            onPressed: onRemove,
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DashboardWidget> _activeWidgets = [];
  final Set<DashboardWidgetType> _activeWidgetTypes = {};

  @override
  void initState() {
    super.initState();
    _addDefaultWidgets();
  }

  void _addDefaultWidgets() {
    _addWidget(DashboardWidgetType.workoutSummary);
    _addWidget(DashboardWidgetType.strengthProgress);
    _addWidget(DashboardWidgetType.weeklyVolume);
  }

  void _addWidget(DashboardWidgetType type) {
    if (_activeWidgetTypes.contains(type)) {
      // Widget already exists
      return;
    }

    setState(() {
      _activeWidgetTypes.add(type);
      _activeWidgets.add(
        DashboardWidget(
          type: type,
          onRemove: () => _removeWidget(type),
          child: _buildWidgetContent(type),
        ),
      );
    });
  }

  void _removeWidget(DashboardWidgetType type) {
    setState(() {
      _activeWidgetTypes.remove(type);
      _activeWidgets.removeWhere((widget) => widget.type == type);
    });
  }

  Widget _buildWidgetContent(DashboardWidgetType type) {
    switch (type) {
      case DashboardWidgetType.workoutSummary:
        return _WorkoutSummaryWidget();
      case DashboardWidgetType.strengthProgress:
        return _StrengthProgressWidget();
      case DashboardWidgetType.weeklyVolume:
        return _WeeklyVolumeWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            if (_activeWidgets.isEmpty)
              _buildEmptyState()
            else
              ..._activeWidgets.expand((widget) => [
                    widget,
                    SizedBox(height: 16), // Add spacing between widgets
                  ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back, ', style: TextStyle(fontSize: 16)),
                Text('gym', style: TextStyle(fontSize: 16)),
              ],
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.add),
              onPressed: _showAddWidgetSheet,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => StartScreen(
                        showNavbar: () => true, hideNavbar: () => false),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Start Workout',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          Icon(
            CupertinoIcons.chart_bar_square,
            size: 64,
            color: CupertinoColors.systemGrey,
          ),
          SizedBox(height: 16),
          Text(
            'Customize Your Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add widgets to track your progress',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          CupertinoButton.filled(
            child: Text('Add Widget'),
            onPressed: _showAddWidgetSheet,
          ),
        ],
      ),
    );
  }

  void _showAddWidgetSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _AddWidgetSheet(
        activeWidgetTypes: _activeWidgetTypes,
        onWidgetAdded: (type) {
          _addWidget(type);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _WorkoutSummaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Workout Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'This Week',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  '4',
                  'Workouts',
                  CupertinoColors.black,
                ),
                _buildSummaryItem(
                  '12,450',
                  'Volume (kg)',
                  CupertinoColors.black,
                ),
                _buildSummaryItem(
                  '185',
                  'Sets',
                  CupertinoColors.black,
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: CupertinoColors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '4 of 5 workouts completed',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _StrengthProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strength Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 3.5),
                        FlSpot(2, 3.2),
                        FlSpot(3, 4),
                        FlSpot(4, 3.8),
                        FlSpot(5, 4.2),
                        FlSpot(6, 4.5),
                      ],
                      isCurved: true,
                      color: CupertinoColors.black,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: CupertinoColors.black.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildExerciseProgress(
                  'Bench Press',
                  '100kg',
                  '+5kg',
                ),
                _buildExerciseProgress(
                  'Squat',
                  '140kg',
                  '+7.5kg',
                ),
                _buildExerciseProgress(
                  'Deadlift',
                  '180kg',
                  '+10kg',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseProgress(String name, String weight, String increase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemGrey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          weight,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          increase,
          style: TextStyle(
            color: CupertinoColors.activeGreen,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _WeeklyVolumeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Volume',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8)]),
                    BarChartGroupData(
                        x: 1, barRods: [BarChartRodData(toY: 10)]),
                    BarChartGroupData(
                        x: 2, barRods: [BarChartRodData(toY: 14)]),
                    BarChartGroupData(
                        x: 3, barRods: [BarChartRodData(toY: 15)]),
                    BarChartGroupData(
                        x: 4, barRods: [BarChartRodData(toY: 13)]),
                    BarChartGroupData(
                        x: 5, barRods: [BarChartRodData(toY: 10)]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 8)]),
                  ],
                  barTouchData: BarTouchData(enabled: false),
                  maxY: 20,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildVolumeMetric('Total Sets', '185'),
                _buildVolumeMetric('Average Weight', '75kg'),
                _buildVolumeMetric('Peak Day', 'Thursday'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemGrey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _AddWidgetSheet extends StatelessWidget {
  final Set<DashboardWidgetType> activeWidgetTypes;
  final Function(DashboardWidgetType) onWidgetAdded;

  const _AddWidgetSheet({
    required this.activeWidgetTypes,
    required this.onWidgetAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.xmark),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Add Widget',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 32),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildWidgetOption(
                  context,
                  'Workout Summary',
                  'Overview of your weekly progress',
                  DashboardWidgetType.workoutSummary,
                ),
                _buildWidgetOption(
                  context,
                  'Strength Progress',
                  'Track your strength gains',
                  DashboardWidgetType.strengthProgress,
                ),
                _buildWidgetOption(
                  context,
                  'Weekly Volume',
                  'Analyze your training volume',
                  DashboardWidgetType.weeklyVolume,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWidgetOption(
    BuildContext context,
    String title,
    String subtitle,
    DashboardWidgetType type,
  ) {
    final bool isActive = activeWidgetTypes.contains(type);

    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: isActive ? null : () => onWidgetAdded(type),
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    color: isActive
                        ? CupertinoColors.systemGrey
                        : CupertinoColors.label,
                  ),
                ),
                Text(
                  isActive ? 'Already added' : subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          if (!isActive)
            Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
            ),
        ],
      ),
    );
  }
}
