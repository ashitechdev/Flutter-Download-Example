import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_file_download_example/services/downloads_path_helper.dart';
import 'package:flutter_file_download_example/services/notifications_helper.dart';
import 'package:flutter_file_download_example/services/permissions_helper.dart';
import 'package:flutter_file_download_example/utils/dummy_data.dart';
import 'package:path/path.dart' as path;

class DownloadingService extends ChangeNotifier {
  double progress;

  String filePath;

  String downloadingStatus = "Not Downloading";

  final Dio _dio = Dio();

  /// utilizing path_provider package
  /// pay attention path_provider is imported as 'path' in imports at top
  Future<void> download({@required DemoData fileDetails}) async {
    // requesting permissions and getting status
    final isPermissionStatusGranted =
        await PermissionsHelper().requestPermissions();

    // getting downloads directory
    final dir = await DownloadsPathHelper().getDownloadDirectory();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, fileDetails.fileName);

      /// and notifyListeners
      downloadingStatus = "downloading...";
      notifyListeners();

      /// everything is okay - we will now prepare download process
      await _startDownload(fileDetails, savePath);
    } else {
      /// handle the scenario when user declines the permissions
      /// and notifyListeners
      downloadingStatus = "User Declined Storage Permissions";
      notifyListeners();
    }
  }

  /// the actual method that downloads the file
  Future<void> _startDownload(DemoData fileDetails, String savePath) async {
    /// making this to pass it into _showNotification() method
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(fileDetails.fileUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      if (response.statusCode == 200) {
        print("downloaded Successfully");

        /// notifyListeners
        downloadingStatus = "Downloaded Successfully";
        filePath = savePath;
        notifyListeners();
      } else
        print(response.statusCode);
    } catch (e) {
      /// notifyListeners
      downloadingStatus = "Error :(";
      notifyListeners();
      print("\nError :" + e.toString() + "\n");
    } finally {
      print("Process Completed");

      /// finally we shows the notification
      NotificationsService().showNotification(result);
    }
  }

  /// added this new function for progress indicator
  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      /// notify Listeners
      progress = (received / total * 100);
      notifyListeners();
    }
  }
}
