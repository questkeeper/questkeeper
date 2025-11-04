import 'package:questkeeper/shared/utils/hex_color.dart';

final primaryColor = HexColor("#a86fd1");
final secondaryColor = HexColor("#FFA751");

const firebaseVapidKey =
    "BJQWJMXxJeMAesRDwHe7jrBl-ApmrqB6g_2kk8mJbGXR1qMfde9rWbD_O1O_SyJGVqi5Off_OdGviWuSlLQCJwA";

// Check if debug mode is enabled
const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

// Base URI for the API
const String baseApiUri =
    isDebug ? "http://localhost:8787/v1" : "https://api.questkeeper.app/v1";
// const String baseApiUri = "https://api.questkeeper.app/v1";
