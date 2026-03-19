import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Symbols.menu),
          onPressed: () {},
        ),
        title: const Text('Stats', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Symbols.history),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 16),
          // Hero Stats Section
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildHeroStatCard(
                  context,
                  title: 'TOTAL DHIKR',
                  value: '12,842',
                  subtitle: '12% more than last week',
                  icon: Symbols.trending_up,
                  color: AppTheme.primary,
                  bgColor: AppTheme.primaryContainer.withOpacity(0.2),
                  borderColor: AppTheme.primary.withOpacity(0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSecondaryStatCard(
                  context,
                  title: 'CURRENT STREAK',
                  value: '14',
                  unit: 'days',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSecondaryStatCard(
                  context,
                  title: 'TIME SPENT',
                  value: '8.5',
                  unit: 'hrs',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Weekly Progress Chart
          _buildWeeklyProgressChart(context),
          const SizedBox(height: 32),
          // Sessions List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Past Sessions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSessionCard(
            context,
            title: 'Subhan Allah',
            subtitle: 'Today • 10:24 AM',
            count: 'x 100',
            status: 'COMPLETED',
            icon: Symbols.spa,
            iconColor: AppTheme.tertiary,
            iconBgColor: AppTheme.tertiary.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          _buildSessionCard(
            context,
            title: 'Alhamdulillah',
            subtitle: 'Yesterday • 8:15 PM',
            count: 'x 33',
            status: 'COMPLETED',
            icon: Symbols.favorite,
            iconColor: AppTheme.primary,
            iconBgColor: AppTheme.primary.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          _buildSessionCard(
            context,
            title: 'Allahu Akbar',
            subtitle: 'Nov 14 • 5:30 AM',
            count: 'x 1000',
            status: 'DAILY GOAL',
            statusColor: AppTheme.primary,
            icon: Symbols.water_drop,
            iconColor: AppTheme.secondary,
            iconBgColor: AppTheme.secondaryContainer.withOpacity(0.5),
          ),
          const SizedBox(height: 32),
          // Empty State Illustration Placeholder
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFf0e8db),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primary.withOpacity(0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Build your habit',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Consistency is the key to inner peace. Keep going!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.onSecondaryContainer.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Symbols.nature,
                  size: 96,
                  color: AppTheme.primary.withOpacity(0.4),
                  fill: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 120), // padding for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeroStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 48,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(icon, color: AppTheme.onSurfaceVariant, size: 16, fill: 1),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.tertiary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressChart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.onBackground.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Progress',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Daily dhikr count activity',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'LAST 7 DAYS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 192,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildChartBar(context, 'MON', 0.4, false),
                _buildChartBar(context, 'TUE', 0.65, false),
                _buildChartBar(context, 'WED', 0.45, false),
                _buildChartBar(context, 'THU', 0.95, true),
                _buildChartBar(context, 'FRI', 0.3, false),
                _buildChartBar(context, 'SAT', 0.55, false),
                _buildChartBar(context, 'SUN', 0.4, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, String day, double heightFraction, bool isToday) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: heightFraction,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday ? AppTheme.primary : AppTheme.primary.withOpacity(0.2),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              day,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isToday ? AppTheme.primary : AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String count,
    required String status,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    Color? statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, fill: 1),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                status,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColor ?? AppTheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
