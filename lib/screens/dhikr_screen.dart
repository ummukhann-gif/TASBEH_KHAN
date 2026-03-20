import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';

class DhikrScreen extends StatelessWidget {
  const DhikrScreen({
    super.key,
    required this.onOpenCounter,
  });

  final VoidCallback onOpenCounter;

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
              'Dhikr library',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              'Choose a remembrance or create your own flow',
              style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width >= 720 ? 2 : 1;
            final contentWidth = math.min(width, 760.0);

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: _DhikrOverview(app: app),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final dhikr = app.allDhikrs[index];
                            return _DhikrCard(
                              dhikr: dhikr,
                              selected: dhikr.id == app.currentDhikr.id,
                              onSelect: () {
                                app.selectDhikr(dhikr.id);
                                onOpenCounter();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${dhikr.title} selected for your next session.')),
                                );
                              },
                              onDelete: dhikr.isCustom ? () => app.removeCustomDhikr(dhikr.id) : null,
                            );
                          },
                          childCount: app.allDhikrs.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: crossAxisCount == 1 ? 1.16 : 0.94,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 84),
        child: FloatingActionButton.extended(
          onPressed: () => _showCreateDhikrSheet(context, app),
          icon: const Icon(Symbols.add_circle),
          label: const Text('Add custom'),
        ),
      ),
    );
  }

  Future<void> _showCreateDhikrSheet(BuildContext context, TasbihAppState app) async {
    final titleController = TextEditingController();
    final arabicController = TextEditingController();
    final translationController = TextEditingController();
    final targetController = TextEditingController(text: '33');
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create a custom dhikr',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title', hintText: 'Example: Salawat'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: arabicController,
                  decoration: const InputDecoration(labelText: 'Arabic text'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Arabic text is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: translationController,
                  decoration: const InputDecoration(labelText: 'Translation'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Translation is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Suggested target'),
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          app.addCustomDhikr(
                            title: titleController.text,
                            arabic: arabicController.text,
                            translation: translationController.text,
                            target: int.parse(targetController.text),
                          );
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${titleController.text.trim()} added to your library.')),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DhikrOverview extends StatelessWidget {
  const _DhikrOverview({required this.app});

  final TasbihAppState app;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.14),
            scheme.tertiary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected now',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            app.currentDhikr.title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            app.currentDhikr.translation,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatPill(icon: Symbols.auto_awesome, label: '${app.allDhikrs.length} dhikr available'),
              _StatPill(icon: Symbols.history, label: '${app.completedSessions} completed sessions'),
              _StatPill(icon: Symbols.stars_2, label: '${app.allDhikrs.where((d) => d.isCustom).length} custom'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  const _DhikrCard({
    required this.dhikr,
    required this.selected,
    required this.onSelect,
    this.onDelete,
  });

  final DhikrDefinition dhikr;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: selected ? scheme.primary.withValues(alpha: 0.10) : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: selected ? scheme.primary.withValues(alpha: 0.30) : scheme.outlineVariant.withValues(alpha: 0.18),
          width: selected ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                foregroundColor: scheme.primary,
                child: Icon(dhikr.icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag(label: dhikr.category),
                    _Tag(label: '${dhikr.suggestedTarget} reps'),
                    if (dhikr.isCustom) _Tag(label: 'Custom'),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Symbols.delete, color: scheme.error),
                  tooltip: 'Delete custom dhikr',
                ),
            ],
          ),
          const Spacer(),
          Text(
            dhikr.arabic,
            textDirection: TextDirection.rtl,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            dhikr.title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            dhikr.translation,
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSelect,
                  icon: Icon(selected ? Symbols.check : Symbols.arrow_forward),
                  label: Text(selected ? 'Selected' : 'Use this'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
