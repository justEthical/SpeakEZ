import 'package:appwrite/appwrite.dart';
import 'dart:io' as io;
import 'package:appwrite/models.dart' show File;
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

  Future<void> getLessons({required String fileName}) async {
    final storage = Storage(client);
    final result = await storage.listFiles(
      bucketId: AppStrings.appStorageBuckerId,
    );
    for (final file in result.files) {
      print('File Name: ${file.name}, File ID: ${file.$id}');
      if (file.name == fileName) {
        await downloadFile(file);
      }
    }
  }

  Future<void> downloadFile(File file) async {
    final storage = Storage(client);
    try {
      final bytes = await storage.getFileDownload(
        bucketId: AppStrings.appStorageBuckerId,
        fileId: file.$id,
      );

      final lessonsDir = io.Directory(
        '${globalController.appDocDirectoryPath}/lessons',
      );

      // Check if lessons folder exists
      if (!await lessonsDir.exists()) {
        await lessonsDir.create(
          recursive: true,
        ); // Create folder if it doesn't exist
      }

      io.File('${lessonsDir.path}/${file.name}');

      await io.File('${lessonsDir.path}/${file.name}').writeAsBytes(bytes);
    } catch (e) {
      print('Error downloading file: $e');
    }
  }
}
