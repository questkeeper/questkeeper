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
  bool _isShowcasing = false;

  Future<void> _saveState() async {
    debugPrint('Saving state');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showcase_shown', false);
    final showcaseShown = prefs.getBool('showcase_shown') ?? false;
    if (!showcaseShown) {
      await prefs.setBool('showcase_shown', true);
    }

    _isShowcasing = false;
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final showcaseShown = prefs.getBool('showcase_shown') ?? false;
    if (!showcaseShown) {
      _isShowcasing = true;
    } else {
      _isShowcasing = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () => _saveState(),
      builder: (context) => AllSpacesScreen(
        isShowcasing: _isShowcasing,
      ),
    );
  }
}
