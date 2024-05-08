import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';

const appwriteEndpoint = "https://cloud.appwrite.io/v1";
const projectId = "663070dc003453890e3c";

Client client = Client().setEndpoint(appwriteEndpoint).setProject(projectId);
Databases database = Databases(client);
Account account = Account(client);
Messaging messaging = Messaging(client);

const publicDb = "public";

final primaryColor = HexColor("#a86fd1");
final secondaryColor = HexColor("#FFA751");

const firebaseVapidKey =
    "BJQWJMXxJeMAesRDwHe7jrBl-ApmrqB6g_2kk8mJbGXR1qMfde9rWbD_O1O_SyJGVqi5Off_OdGviWuSlLQCJwA";
