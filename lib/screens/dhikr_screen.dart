import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class DhikrScreen extends StatelessWidget {
  const DhikrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Terra Tasbih', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const SizedBox(height: 16),
          // Header Section
          Text(
            'Daily Dhikr',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a remembrance to begin your session',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.secondary,
                ),
          ),
          const SizedBox(height: 24),
          // Dhikr List Cards
          _buildDhikrCard(
            context,
            category: 'MORNING',
            icon: Symbols.auto_awesome,
            arabicText: 'سُبْحَانَ اللهِ',
            title: 'Subhanallah',
            translation: 'Glory be to Allah',
            targetCount: 33,
            categoryColor: AppTheme.tertiary,
            categoryBgColor: AppTheme.tertiary.withOpacity(0.1),
            iconColor: AppTheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          _buildDhikrCard(
            context,
            category: 'ESSENTIAL',
            icon: Symbols.verified_user,
            arabicText: 'الْحَمْدُ لِلَّهِ',
            title: 'Alhamdulillah',
            translation: 'Praise be to Allah',
            targetCount: 33,
            categoryColor: AppTheme.tertiary,
            categoryBgColor: AppTheme.tertiary.withOpacity(0.1),
            iconColor: AppTheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          _buildDhikrCard(
            context,
            category: 'GREATNESS',
            icon: Symbols.filter_vintage,
            arabicText: 'اللهُ أَكْبَرُ',
            title: 'Allahu Akbar',
            translation: 'Allah is the Greatest',
            targetCount: 34,
            categoryColor: AppTheme.tertiary,
            categoryBgColor: AppTheme.tertiary.withOpacity(0.1),
            iconColor: AppTheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          _buildDhikrCard(
            context,
            category: 'ISTIGHFAR',
            icon: Symbols.spa,
            arabicText: 'أَسْتَغْفِرُ اللهَ',
            title: 'Astaghfirullah',
            translation: 'I seek forgiveness from Allah',
            targetCount: 100,
            categoryColor: AppTheme.onPrimaryFixedVariant,
            categoryBgColor: AppTheme.primary.withOpacity(0.2),
            iconColor: AppTheme.primary.withOpacity(0.4),
            bgColor: AppTheme.secondaryContainer,
            borderColor: AppTheme.primary.withOpacity(0.1),
          ),
          const SizedBox(height: 120), // padding for bottom nav & fab
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Above bottom nav
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppTheme.tertiaryFixed,
          foregroundColor: AppTheme.onTertiaryFixed,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Symbols.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildDhikrCard(
    BuildContext context, {
    required String category,
    required IconData icon,
    required String arabicText,
    required String title,
    required String translation,
    required int targetCount,
    required Color categoryColor,
    required Color categoryBgColor,
    required Color iconColor,
    Color bgColor = AppTheme.surfaceContainerLow,
    Color borderColor = Colors.transparent,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppTheme.onBackground.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                ),
              ),
              Icon(icon, color: iconColor),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              arabicText,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                    height: 2.0, // leading-loose equivalent
                  ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            translation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryFixedDim,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.surface, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$targetCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                iconAlignment: IconAlignment.end,
                icon: const Icon(Symbols.arrow_forward, size: 16),
                label: const Text('Select'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
