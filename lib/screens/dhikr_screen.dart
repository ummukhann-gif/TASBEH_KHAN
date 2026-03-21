import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';

class DhikrScreen extends StatelessWidget {
  const DhikrScreen({
    super.key,
    required this.onOpenCounter,
    required this.onOpenAdd,
  });

  final VoidCallback onOpenCounter;
  final Future<void> Function() onOpenAdd;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final strings = app.strings;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: scheme.tertiaryContainer,
        foregroundColor: scheme.onTertiaryContainer,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: onOpenAdd,
        child: const Icon(Symbols.add),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              children: [
                Text(
                  strings.appTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  strings.dailyDhikrTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  strings.selectRemembrance,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                for (final dhikr in app.allDhikrs) ...[
                  _DhikrCard(
                    dhikr: dhikr,
                    selected: dhikr.id == app.currentDhikr.id,
                    selectLabel: strings.select,
                    currentLabel: strings.current,
                    onSelect: () {
                      app.selectDhikr(dhikr.id);
                      onOpenCounter();
                    },
                    onDelete: dhikr.isCustom
                        ? () => _showDeleteDialog(context, app, dhikr.id)
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    TasbihAppState app,
    String dhikrId,
  ) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete custom dhikr?'),
          content: const Text(
            'This removes the dhikr and its saved session history.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(app.strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (delete == true) {
      app.removeCustomDhikr(dhikrId);
    }
  }
}

class _DhikrCard extends StatelessWidget {
  const _DhikrCard({
    required this.dhikr,
    required this.selected,
    required this.selectLabel,
    required this.currentLabel,
    required this.onSelect,
    this.onDelete,
  });

  final DhikrDefinition dhikr;
  final bool selected;
  final String selectLabel;
  final String currentLabel;
  final VoidCallback onSelect;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected
              ? scheme.primary.withValues(alpha: 0.4)
              : scheme.primary.withValues(alpha: 0.08),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Symbols.delete, color: scheme.error, size: 18),
                )
              else
                const SizedBox(width: 4),
              Expanded(
                child: Text(
                  dhikr.arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dhikr.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dhikr.translation,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${dhikr.suggestedTarget}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selected
                          ? scheme.primary.withValues(alpha: 0.92)
                          : scheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(selected ? currentLabel : selectLabel),
                        const SizedBox(width: 6),
                        const Icon(Symbols.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
