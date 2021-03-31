import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _fileUrl =
      "https://scontent-del1-2.cdninstagram.com/v/t51.2885-19/s320x320/118716589_2704408639814164_6332753775082088537_n.jpg?tp=1&_nc_ht=scontent-del1-2.cdninstagram.com&_nc_ohc=OMT9dX2jr2cAX8TVp53&ccb=7-4&oh=bf70488fc034c3c87091f8fa0e24b7ad&oe=608C563D&_nc_sid=7bff83";

  /// we know the file is an image
  /// so we have already specified the extention .jpg
  /// try a different fileUrl and fileName to experiment with other formats
  final String _fileName = "DSCF0277.jpg";

  String filePath;

  String downloadingStatus = "Not Downloading";

  final Dio _dio = Dio();

  /// creating Flutter local Notifications Object
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    /// initializing Flutter local Notifications Object
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
  }

  /// this method is called when we need to show a notification
  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  /// what happens when we the user taps-on/Selects the notification
  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  /// utilizing permissions_handler package
  Future<bool> _requestPermissions() async {
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

  /// utilizing downloads_path_provider_28 package
  Future<Directory> _getDownloadDirectory() async {
    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary
    // iOS directory visible to user
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    } else
      return await getApplicationDocumentsDirectory();
  }

  /// utilizing path_provider package
  /// pay attention path_provider is imported as 'path' in imports at top
  Future<void> _download() async {
    // requesting permissions and getting status
    final isPermissionStatusGranted = await _requestPermissions();

    // getting downloads directory
    final dir = await _getDownloadDirectory();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, _fileName);
      setState(() {
        downloadingStatus = "downloading...";
      });

      /// everything is okay - we will now prepare download process
      await _startDownload(savePath);
    } else {
      // handle the scenario when user declines the permissions
      setState(() {
        downloadingStatus = "User Declined Storage Permissions";
      });
    }
  }

  /// the actual method that downloads the file
  Future<void> _startDownload(String savePath) async {
    /// making this to pass it into _showNotification() method
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(_fileUrl, savePath);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      if (response.statusCode == 200) {
        print("downloaded Successfully");
        setState(() {
          downloadingStatus = "Downloaded Successfully";
          filePath = savePath;
        });
      } else
        print(response.statusCode);
    } catch (e) {
      setState(() {
        downloadingStatus = "Error :(";
      });
      print("\nError :" + e.toString() + "\n");
    } finally {
      print("Process Completed");

      /// finally we shows the notification
      await _showNotification(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("lmao Title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "this is the network image\nwe want to download",
              textScaleFactor: 1.5,
            ),
            Container(
              margin: EdgeInsets.all(25),
              padding: EdgeInsets.all(10),
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_fileUrl), fit: BoxFit.cover),
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  _download();
                },
                child: Text("Download File"),
                color: Colors.orange.shade100,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text("Status : " + downloadingStatus),

            /// open file button will only appear if
            /// downloadingStatus == "Downloaded Successfully"
            downloadingStatus == "Downloaded Successfully"
                ? TextButton(
                    onPressed: () {
                      OpenFile.open(filePath);
                    },
                    child: Text("Open File"))
                : Container(),
            SizedBox(
              height: 180,
            ),
          ],
        ),
      ),
    );
  }
}
