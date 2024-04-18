import 'package:appwrite/appwrite.dart';

const appwriteEndpoint = "https://appwrite.hayhay.dev/v1";
const projectId = "661e90420031a22ce300";

Client client = Client().setEndpoint(appwriteEndpoint).setProject(projectId);
Databases database = Databases(client);
Account account = Account(client);
Messaging messaging = Messaging(client);

const publicDb = "public";

List<String> getPermissions(String userId) {
  return [
    Permission.read(Role.user(userId)),
    Permission.write(Role.user(userId)),
    Permission.update(Role.user(userId)),
    Permission.delete(Role.user(userId)),
  ];
}
