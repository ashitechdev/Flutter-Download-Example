import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  /// utilizing permissions_handler package
  Future<bool> requestPermissions() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    // if permission not granted
    if (permission != PermissionStatus.granted) {
      // asking for permission
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
    // else if permission already granted
    return permission == PermissionStatus.granted;
  }
}
