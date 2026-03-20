import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              'Tune goals, feedback, and visual comfort',
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(constraints.maxWidth, 640.0);
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 128),
                  children: [
                    _SectionCard(
                      title: 'Session goal',
                      subtitle: 'Choose how targets are applied for every round.',
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _GoalChip(
                            label: 'Auto',
                            selected: app.goalPreset == 0,
                            onTap: () => app.setGoalPreset(0),
                          ),
                          _GoalChip(
                            label: '33',
                            selected: app.goalPreset == 33,
                            onTap: () => app.setGoalPreset(33),
                          ),
                          _GoalChip(
                            label: '99',
                            selected: app.goalPreset == 99,
                            onTap: () => app.setGoalPreset(99),
                          ),
                          _GoalChip(
                            label: '100',
                            selected: app.goalPreset == 100,
                            onTap: () => app.setGoalPreset(100),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Feedback',
                      subtitle: 'Keep tapping responsive without becoming distracting.',
                      child: Column(
                        children: [
                          _SettingSwitchTile(
                            icon: app.hapticsEnabled ? Symbols.vibration : Symbols.block,
                            title: 'Haptics',
                            subtitle: 'Physical feedback on every tap',
                            value: app.hapticsEnabled,
                            onChanged: app.setHapticsEnabled,
                          ),
                          const SizedBox(height: 14),
                          _SettingSwitchTile(
                            icon: app.soundEnabled ? Symbols.volume_up : Symbols.volume_off,
                            title: 'Sound',
                            subtitle: 'Soft system click while counting',
                            value: app.soundEnabled,
                            onChanged: app.setSoundEnabled,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Intensity',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '${(app.intensity * 100).round()}%',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: app.intensity,
                            onChanged: app.setIntensity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Appearance',
                      subtitle: 'Keep the interface comfortable on bright or dim screens.',
                      child: Column(
                        children: [
                          _SettingSwitchTile(
                            icon: app.darkModeEnabled ? Symbols.dark_mode : Symbols.light_mode,
                            title: 'Dark mode',
                            subtitle: 'Switch theme across the entire app',
                            value: app.darkModeEnabled,
                            onChanged: app.setDarkModeEnabled,
                          ),
                          const SizedBox(height: 16),
                          _ThemePreviewCard(darkModeEnabled: app.darkModeEnabled),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Data',
                      subtitle: 'Remove stats, sessions, and active progress when needed.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${app.completedSessions} sessions saved • ${app.totalCount} total counts',
                            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: () => _confirmReset(context, app),
                            icon: Icon(Symbols.delete_forever, color: scheme.error),
                            label: Text(
                              'Reset all progress',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: scheme.error,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: scheme.error.withValues(alpha: 0.10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, TasbihAppState app) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset all progress?'),
          content: const Text(
            'This removes saved sessions, streaks, and the current counter state.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (approved == true && context.mounted) {
      app.resetAllProgress();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All progress has been reset.')),
      );
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  const _GoalChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? scheme.primary.withValues(alpha: 0.14) : scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? scheme.primary.withValues(alpha: 0.30) : scheme.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SettingSwitchTile extends StatelessWidget {
  const _SettingSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: scheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard({
    required this.darkModeEnabled,
  });

  final bool darkModeEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: darkModeEnabled
              ? [
                  const Color(0xFF1A201D),
                  const Color(0xFF24312A),
                ]
              : [
                  scheme.primary.withValues(alpha: 0.16),
                  scheme.tertiary.withValues(alpha: 0.10),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  darkModeEnabled ? 'Night focus mode' : 'Soft daylight mode',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: darkModeEnabled ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  darkModeEnabled
                      ? 'Muted contrast for long evening sessions.'
                      : 'Warm contrast for comfortable daytime reading.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: darkModeEnabled ? Colors.white70 : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            darkModeEnabled ? Symbols.dark_mode : Symbols.sunny,
            size: 42,
            color: darkModeEnabled ? Colors.white : scheme.primary,
          ),
        ],
      ),
    );
  }
}
