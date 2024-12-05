import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:questkeeper/spaces/views/all_spaces_screen.dart';

class ShowcaseAllSpacesScreen extends StatefulWidget {
  const ShowcaseAllSpacesScreen({super.key});

  @override
  State<ShowcaseAllSpacesScreen> createState() =>
      _ShowcaseAllSpacesScreenState();
}

class _ShowcaseAllSpacesScreenState extends State<ShowcaseAllSpacesScreen> {
  late final ValueNotifier<bool> _isShowcasing = ValueNotifier<bool>(true);

  Future<void> _saveState() async {
    debugPrint('Saving state');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showcase_shown', true);
    _isShowcasing.value = false;
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showcase_shown', false);  // Force showcase for testing
    debugPrint('Loading showcase state');
    _isShowcasing.value = true;
  }

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return ShowCaseWidget(
      enableShowcase: _isShowcasing,
      onFinish: () => setState(() {
        _isShowcasing = false;
        _saveState();
      }),
      builder: (context) => AllSpacesScreen(
        isShowcasing: _isShowcasing,
      ),
=======
    return ValueListenableBuilder<bool>(
      valueListenable: _isShowcasing,
      builder: (context, value, child) {
        debugPrint('Showcase value: $value');
        return ShowCaseWidget(
          enableAutoScroll: true,
          enableShowcase: true,  // Always enable for now
          onComplete: (index, key) {
            debugPrint('Showcase complete: $index');
            if (index == 2) {  // Last item
              _saveState();
            }
          },
          builder: (context) => AllSpacesScreen(
            isShowcasing: true,  // Always true for now
          ),
        );
      },
>>>>>>> Stashed changes
    );
  }
}
