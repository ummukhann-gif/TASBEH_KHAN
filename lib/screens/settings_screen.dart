import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';
import '../app_strings.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final strings = app.strings;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            children: [
              Text(
                strings.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: scheme.primary),
              ),
              const SizedBox(height: 20),
              Text(
                strings.settings,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tailor your spiritual practice',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _SettingsSection(
                title: strings.targetCount,
                icon: Symbols.adjust,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _ChoiceButton(
                            label: '33',
                            selected: app.goalPreset == 33,
                            onTap: () => app.setGoalPreset(33),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ChoiceButton(
                            label: '99',
                            selected: app.goalPreset == 99,
                            onTap: () => app.setGoalPreset(99),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ChoiceButton(
                            label: strings.infinity,
                            selected: app.goalPreset == -1,
                            onTap: () => app.setGoalPreset(-1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: strings.enterCustomTarget,
                        suffixIcon: const Icon(Symbols.ads_click),
                      ),
                      onSubmitted: (value) {
                        final parsed = int.tryParse(value.trim());
                        if (parsed != null && parsed > 0) {
                          app.setGoalPreset(parsed);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        strings.maximumValue,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 380;

                  if (compact) {
                    return Column(
                      children: [
                        _ToggleCard(
                          icon: Symbols.vibration,
                          accentColor: scheme.primary,
                          title: strings.haptic,
                          subtitle: strings.hapticDesc,
                          value: app.hapticsEnabled,
                          compact: true,
                          onChanged: app.setHapticsEnabled,
                        ),
                        const SizedBox(height: 14),
                        _ToggleCard(
                          icon: Symbols.volume_up,
                          accentColor: scheme.tertiary,
                          title: strings.sound,
                          subtitle: strings.soundDesc,
                          value: app.soundEnabled,
                          compact: true,
                          onChanged: app.setSoundEnabled,
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: _ToggleCard(
                          icon: Symbols.vibration,
                          accentColor: scheme.primary,
                          title: strings.haptic,
                          subtitle: strings.hapticDesc,
                          value: app.hapticsEnabled,
                          onChanged: app.setHapticsEnabled,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _ToggleCard(
                          icon: Symbols.volume_up,
                          accentColor: scheme.tertiary,
                          title: strings.sound,
                          subtitle: strings.soundDesc,
                          value: app.soundEnabled,
                          onChanged: app.setSoundEnabled,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: strings.textAppearance,
                icon: Symbols.text_fields,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Symbols.text_fields,
                          size: 18,
                          color: scheme.onSurfaceVariant,
                        ),
                        Expanded(
                          child: Slider(
                            value: app.textScale,
                            min: 0.9,
                            max: 1.3,
                            divisions: 4,
                            onChanged: app.setTextScale,
                          ),
                        ),
                        Icon(
                          Symbols.text_fields,
                          size: 24,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            strings.defaultTextSize,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        Text(
                          strings.largerTextSize,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: strings.appLanguage,
                icon: Symbols.language,
                child: Column(
                  children: [
                    for (final language in AppLanguage.values) ...[
                      _WideChoiceButton(
                        label: language.label,
                        selected: app.language == language,
                        onTap: () => app.setLanguage(language),
                      ),
                      if (language != AppLanguage.values.last)
                        const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _SettingsSection(
                title: strings.appTheme,
                icon: Symbols.palette,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      strings.darkMode,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: app.darkModeEnabled,
                      onChanged: app.setDarkModeEnabled,
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 104,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppPalette.values.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final palette = AppPalette.values[index];
                      return _PaletteOption(
                        palette: palette,
                        selected: app.palette == palette,
                        onTap: () => app.setPalette(palette),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.error,
                  side: BorderSide(
                    color: scheme.error.withValues(alpha: 0.2),
                    width: 1.4,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () => _confirmReset(context, app, strings),
                icon: const Icon(Symbols.restart_alt),
                label: Text(strings.resetAllProgress),
              ),
              const SizedBox(height: 24),
              Opacity(
                opacity: 0.4,
                child: Column(
                  children: [
                    Text(
                      'Terra Tasbih v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Crafted for mindful presence',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    TasbihAppState app,
    AppStrings strings,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.confirmResetTitle),
          content: Text(strings.confirmResetBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(strings.reset),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      app.resetAllProgress();
    }
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(compact ? 16 : 18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 38 : 40,
            height: compact ? 38 : 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: compact ? 17 : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: compact ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: selected ? scheme.primary : scheme.surfaceContainer,
        foregroundColor: selected ? scheme.onPrimary : scheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(label),
    );
  }
}

class _WideChoiceButton extends StatelessWidget {
  const _WideChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: selected ? scheme.primary : scheme.surfaceContainer,
        foregroundColor: selected ? scheme.onPrimary : scheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (selected) const Icon(Symbols.check_circle, fill: 1, size: 18),
        ],
      ),
    );
  }
}

class _PaletteOption extends StatelessWidget {
  const _PaletteOption({
    required this.palette,
    required this.selected,
    required this.onTap,
  });

  final AppPalette palette;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final previewTheme = AppTheme.buildTheme(
      palette: palette,
      brightness: Brightness.light,
    );
    final scheme = previewTheme.colorScheme;
    final currentScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? currentScheme.primary : Colors.transparent,
                width: 2.6,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: currentScheme.primary.withValues(alpha: 0.18),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: selected
                    ? Icon(Symbols.check, color: currentScheme.onPrimary)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            palette.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected
                  ? currentScheme.primary
                  : currentScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
