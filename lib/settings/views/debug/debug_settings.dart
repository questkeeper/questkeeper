import 'package:flutter/material.dart';
import 'package:questkeeper/shared/utils/shared_preferences_manager.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';

class SuperSecretDebugSettings extends StatelessWidget {
  const SuperSecretDebugSettings({super.key});
  static final prefs = SharedPreferencesManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Secret Debug Settings'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text("Show me da local data"),
            onTap: () {
              // showDrawer(
              //   context: context,
              //   child: _localDataStorage(),
              //   key: "localData",
              // );
              showModalBottomSheet(
                  context: context, builder: (context) => _localDataStorage());
            },
          ),
        ],
      ),
    );
  }

  Widget _localDataStorage() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            "Local data cached in SharedPreferences",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          _distinctListTiles(
            title: "Clear primary onboarding status",
            onTap: () async => await prefs.remove('onboarded'),
            key: "onboarded",
            description:
                "Clears the primary onboarding status shown at the beginning of the app",
          ),
          _distinctListTiles(
            key: "onboard_overlay",
            title: "Clear the in-app onboarding overlay",
            onTap: () async {
              await prefs.remove('onboarding_completed_steps');
              await prefs.remove('onboarding_complete');
            },
            description:
                "Clears the onboarding overlay once logged in, resets the overlay to show again",
          ),
        ],
      ),
    );
  }

  Widget _distinctListTiles({
    required String title,
    required Function onTap,
    required String key,
    String? description,
  }) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(title),
          subtitle: description != null ? Text(description) : null,
          onTap: () async {
            await onTap();
            SnackbarService.showInfoSnackbar(
              "Cleared $key",
            );
          },
        ),
      ),
    );
  }
}
