import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../app_state.dart';

class AddDhikrScreen extends StatefulWidget {
  const AddDhikrScreen({super.key});

  @override
  State<AddDhikrScreen> createState() => _AddDhikrScreenState();
}

class _AddDhikrScreenState extends State<AddDhikrScreen> {
  final _nameController = TextEditingController();
  final _arabicController = TextEditingController();
  final _customTargetController = TextEditingController(text: '100');
  int? _selectedTarget = 33;

  @override
  void dispose() {
    _nameController.dispose();
    _arabicController.dispose();
    _customTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final strings = app.strings;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 160,
            right: -60,
            child: _BlurOrb(
              color: scheme.primary.withValues(alpha: 0.1),
              size: 220,
            ),
          ),
          Positioned(
            bottom: 160,
            left: -80,
            child: _BlurOrb(
              color: scheme.tertiary.withValues(alpha: 0.08),
              size: 260,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(strings.cancel),
                          ),
                          Expanded(
                            child: Text(
                              'Tasbeh',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: scheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 72),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(top: 18),
                          children: [
                            Text(
                              strings.newDhikrTitle,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              strings.newDhikrBody,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _FieldLabel(strings.dhikrName),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Masalan: SubhanAllah',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _FieldLabel(strings.arabicText),
                                ),
                                Text(
                                  strings.optional,
                                  style: theme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _arabicController,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: scheme.primary.withValues(alpha: 0.5),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'سُبْحَانَ ٱللَّٰهِ',
                              ),
                            ),
                            const SizedBox(height: 24),
                            _FieldLabel(strings.targetCount),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _TargetOption(
                                    label: '33',
                                    subtitle: 'Sunti',
                                    selected: _selectedTarget == 33,
                                    onTap: () =>
                                        setState(() => _selectedTarget = 33),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _TargetOption(
                                    label: '99',
                                    subtitle: 'Asmo',
                                    selected: _selectedTarget == 99,
                                    onTap: () =>
                                        setState(() => _selectedTarget = 99),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _TargetOption(
                                    label: null,
                                    subtitle: 'Boshqa',
                                    selected: _selectedTarget == null,
                                    icon: Symbols.edit,
                                    onTap: () =>
                                        setState(() => _selectedTarget = null),
                                  ),
                                ),
                              ],
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              child: _selectedTarget == null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: TextField(
                                        controller: _customTargetController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: strings.enterCustomTarget,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: scheme.tertiaryContainer.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: scheme.tertiary.withValues(
                                    alpha: 0.14,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Symbols.info,
                                    color: scheme.tertiary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      strings.infoHint,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: scheme.onTertiaryContainer,
                                            height: 1.5,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                strings.save,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: scheme.onPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Symbols.check_circle, fill: 1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final app = AppScope.of(context);
    final strings = app.strings;
    final name = _nameController.text.trim();
    final target =
        _selectedTarget ?? int.tryParse(_customTargetController.text.trim());

    if (name.isEmpty) {
      _showMessage(strings.enterNameError);
      return;
    }

    if (target == null || target <= 0) {
      _showMessage(strings.enterTargetError);
      return;
    }

    final id = app.addCustomDhikr(
      title: name,
      arabic: _arabicController.text.trim(),
      target: target,
    );
    app.selectDhikr(id);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.savedSuccessfully)));
    Navigator.pop(context, true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        letterSpacing: 1.6,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _TargetOption extends StatelessWidget {
  const _TargetOption({
    this.label,
    this.icon,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String? label;
  final IconData? icon;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? scheme.primary.withValues(alpha: 0.12)
          : scheme.surfaceContainerHigh.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Column(
            children: [
              if (icon != null)
                Icon(icon, color: scheme.onSurface)
              else
                Text(
                  label!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  const _BlurOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 70, spreadRadius: 12),
          ],
        ),
      ),
    );
  }
}
