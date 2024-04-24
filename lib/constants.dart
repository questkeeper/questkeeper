import 'package:appwrite/appwrite.dart';
import 'package:assigngo_rewrite/shared/utils/hex_color.dart';

const appwriteEndpoint = "https://appwrite.hayhay.dev/v1";
const projectId = "661e90420031a22ce300";

Client client = Client().setEndpoint(appwriteEndpoint).setProject(projectId);
Databases database = Databases(client);
Account account = Account(client);
Messaging messaging = Messaging(client);

const publicDb = "public";

final primaryColor = HexColor("#a86fd1");
final secondaryColor = HexColor("#FFA751");
