import 'package:flutter/material.dart';
import 'package:flutter_file_download_example/services/downloading_service.dart';
import 'package:flutter_file_download_example/views/homepage.dart';
import 'package:provider/provider.dart';

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
      home: ChangeNotifierProvider<DownloadingService>(
          create: (_) => DownloadingService(), child: MyHomePage()),
    );
  }
}
