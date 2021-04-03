import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsPathHelper {
  /// utilizing downloads_path_provider_28 package
  Future<Directory> getDownloadDirectory() async {
    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary
    // iOS directory visible to user
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    } else
      return await getApplicationDocumentsDirectory();
  }
}
