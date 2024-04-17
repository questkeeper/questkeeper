import 'package:appwrite/appwrite.dart';

const supabaseUrl = 'https://mzudaknbrzixjkvjqayw.supabase.co';
const supabaseKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16dWRha25icnppeGprdmpxYXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI0MjU3NDgsImV4cCI6MjAyODAwMTc0OH0.b71_fWtic8S4sfNmCMlwLAlzZwhS_lHGBEW1ZQynfsc";

const appwriteEndpoint = "https://appwrite.hayhay.dev/v1";
const projectId = "661e90420031a22ce300";

Client client = Client();
Databases database = Databases(client);
Account account = Account(client);

const publicDb = "public";

List<String> defaultPermissions = [
  Permission.read(Role.user("[USER_ID]")),
  Permission.write(Role.user("[USER_ID]")),
  Permission.update(Role.user("[USER_ID]")),
  Permission.delete(Role.user("[USER_ID]"))
];
