import 'package:appwrite/appwrite.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class AppwriteService {
  Client client = Client();

  AppwriteService() {
    client
        .setEndpoint(AppStrings.appWriteEndPointUrl) // Your Appwrite Endpoint
        .setProject(AppStrings.appWriteProjectId) // Your project ID
        .setSelfSigned() // Use only on dev mode with a self-signed SSL cert
        ;
  }

  Future<void> getLessons({required String level}) async {
    final storage = Storage(client);
final result = await storage.listFiles(bucketId: AppStrings.appStorageBuckerId);
for (final file in result.files) {
  print('File Name: ${file.name}, File ID: ${file.$id}');
}
    try{
      final result = await storage.getFile(
      bucketId: AppStrings.appStorageBuckerId,
      fileId: '689347db001e1d86b717',
    );
    globalController.showSnackbarWithGetX('Success', result.name);
    print(result.name);
    }catch(error){
      print(error.toString());
      globalController.showSnackbarWithGetX("Error", error.toString());
    }
    
  }
}
