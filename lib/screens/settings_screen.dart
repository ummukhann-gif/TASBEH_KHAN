import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _targetCount = 33;
  bool _hapticEnabled = true;
  bool _soundEnabled = false;
  bool _darkModeEnabled = false;
  double _intensity = 0.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Symbols.menu),
          onPressed: () {},
        ),
        title: const Text('Terra Tasbih', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Symbols.history),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const SizedBox(height: 16),
          // Header Section
          Text(
            'Settings',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tailor your spiritual practice',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 32),
          // Bento Grid Settings
          _buildTargetCountSection(context),
          const SizedBox(height: 16),
          _buildToggleSetting(
            context,
            icon: Symbols.vibration,
            title: 'Haptic',
            subtitle: 'Vibrate on count',
            value: _hapticEnabled,
            onChanged: (val) => setState(() => _hapticEnabled = val),
            iconColor: AppTheme.primary,
            iconBgColor: AppTheme.primaryContainer.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          _buildToggleSetting(
            context,
            icon: Symbols.volume_up,
            title: 'Sound',
            subtitle: 'Audible feedback',
            value: _soundEnabled,
            onChanged: (val) => setState(() => _soundEnabled = val),
            iconColor: AppTheme.tertiary,
            iconBgColor: AppTheme.tertiaryContainer.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          _buildAppearanceSection(context),
          const SizedBox(height: 16),
          // Reset Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.error.withOpacity(0.2),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Symbols.restart_alt, color: AppTheme.error),
                const SizedBox(width: 8),
                Text(
                  'Reset All Session Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  'Terra Tasbih v2.4.0',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.onSurfaceVariant.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Crafted for Mindful Presence',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 120), // padding for bottom nav
        ],
      ),
    );
  }

  Widget _buildTargetCountSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Symbols.adjust, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Target Count',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTargetButton(33, '33')),
              const SizedBox(width: 12),
              Expanded(child: _buildTargetButton(99, '99')),
              const SizedBox(width: 12),
              Expanded(child: _buildTargetButton(-1, '', icon: Symbols.all_inclusive)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetButton(int value, String label, {IconData? icon}) {
    final isSelected = _targetCount == value;
    return GestureDetector(
      onTap: () => setState(() => _targetCount = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.outlineVariant.withOpacity(0.3),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: isSelected ? AppTheme.onPrimary : AppTheme.primary,
                )
              : Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? AppTheme.onPrimary : AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
            inactiveTrackColor: AppTheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryContainer.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Symbols.dark_mode, color: AppTheme.secondary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'Gentle on the eyes',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: _darkModeEnabled,
                onChanged: (val) => setState(() => _darkModeEnabled = val),
                activeColor: AppTheme.primary,
                inactiveTrackColor: AppTheme.surfaceContainerHighest,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Intensity',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${(_intensity * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Custom Slider Slider Pattern
          SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Icon(Symbols.light_mode, color: AppTheme.primary.withOpacity(0.2), size: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(Symbols.light_mode, color: AppTheme.primary.withOpacity(0.2)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8 * _intensity, // Approx sizing for demo
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.2),
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 48,
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                    thumbColor: AppTheme.primary,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16, elevation: 2),
                    overlayColor: AppTheme.primary.withOpacity(0.1),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                  ),
                  child: Slider(
                    value: _intensity,
                    onChanged: (val) => setState(() => _intensity = val),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
