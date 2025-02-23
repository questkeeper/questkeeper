import 'package:flutter/material.dart';
import 'package:questkeeper/settings/widgets/settings_switch_tile.dart';
import 'package:questkeeper/shared/providers/theme_notifier.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  static final ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  void initState() {
    super.initState();
    themeNotifier.init();
  }

  void onToggleTheme(bool newValue) {
    themeNotifier.setThemeToDark(newValue);
  }

  void onChangeTextScale(double value) {
    themeNotifier.setTextScale(value);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme settings"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dark mode toggle
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier.themeModeNotifier,
                builder: (context, themeMode, child) {
                  return SettingsSwitchTile(
                    isEnabled: themeMode == ThemeMode.dark,
                    onTap: (_) => onToggleTheme(themeMode == ThemeMode.dark),
                    title: "Enable dark mode",
                    description:
                        "Enable or disable dark mode. Default follows system setting.",
                  );
                },
              ),

              const SizedBox(height: 24),

              // Text scale slider
              Text(
                "Text Size",
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<double>(
                valueListenable: themeNotifier.textScaleNotifier,
                builder: (context, scale, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.text_fields, size: 16),
                          Expanded(
                            child: Slider(
                              value: scale,
                              min: 0.8,
                              max: 1.4,
                              divisions: 6,
                              label: '${(scale * 100).round()}%',
                              onChanged: onChangeTextScale,
                            ),
                          ),
                          const Icon(Icons.text_fields, size: 24),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Sample text at ${(scale * 100).round()}% size",
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize:
                                (textTheme.bodyMedium?.fontSize ?? 14) * scale,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Beta notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Theme settings is currently in beta. QuestKeeper may need to be restarted to apply some changes.",
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
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
}
