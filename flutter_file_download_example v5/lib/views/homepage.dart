import 'package:flutter/material.dart';
import 'package:flutter_file_download_example/services/downloading_service.dart';
import 'package:flutter_file_download_example/services/notifications_helper.dart';
import 'package:flutter_file_download_example/utils/dummy_data.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    NotificationsService().initializeNotifs();
    super.initState();
  }

  DemoData chosenData = data.elementAt(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("lmao Title"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Text(
                "dropdown to the file\nyou want to download",
                textScaleFactor: 1.5,
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButton<DemoData>(
                focusColor: Colors.white,
                value: chosenData,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: data.map<DropdownMenuItem<DemoData>>((DemoData value) {
                  return DropdownMenuItem<DemoData>(
                    value: value,
                    child: Center(
                      child: Text(
                        value.fileType,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
                hint: Text(
                  "Please choose a langauage",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (DemoData value) {
                  Provider.of<DownloadingService>(context, listen: false)
                      .progress = null;
                  Provider.of<DownloadingService>(context, listen: false)
                      .downloadingStatus = "Not Downloading";
                  setState(() {
                    chosenData = value;
                  });
                },
              ),

              chosenData.fileType == "Image" || chosenData.fileType == "Gif"
                  ? Container(
                      margin: EdgeInsets.all(25),
                      padding: EdgeInsets.all(10),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(chosenData.fileUrl),
                              fit: BoxFit.cover),
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          )),
                    )
                  : Container(
                      margin: EdgeInsets.all(25),
                      padding: EdgeInsets.all(10),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          )),
                      child: chosenData.fileType == "PDF"
                          ? Icon(Icons.picture_as_pdf, size: 50)
                          : chosenData.fileType == "Video"
                              ? Icon(Icons.video_collection, size: 50)
                              : Icon(Icons.audiotrack, size: 50),
                    ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () {
                    Provider.of<DownloadingService>(context, listen: false)
                        .download(fileDetails: chosenData);
                    print("button pressed");
                    print(chosenData.fileType);
                  },
                  child: Text("Download File"),
                  color: Colors.orange.shade100,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Selector<DownloadingService, String>(
                selector: (buildContext, downloadingServiceProvider) =>
                    downloadingServiceProvider.downloadingStatus,
                builder: (context, status, child) {
                  print("builded status widget");

                  return Text("Status : " + status);
                },
              ),
              Selector<DownloadingService, double>(
                selector: (buildContext, downloadingServiceProvider) =>
                    downloadingServiceProvider.progress,
                builder: (context, progress, child) {
                  print("builded progress widget");
                  return progress == null
                      ? Container()
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    right: 10,
                                    left: 10,
                                    top: 10,
                                    bottom: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 8,
                                      backgroundColor: Colors.grey,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.green),
                                      value: progress / 100,
                                    ),
                                  ),
                                  Text(progress.toStringAsFixed(0) + " %")
                                ],
                              ),
                            ),
                          ],
                        );
                },
              ),
              SizedBox(
                height: 20,
              ),

              /// open file button will only appear if
              /// downloadingStatus == "Downloaded Successfully"
              Selector<DownloadingService, String>(
                selector: (buildContext, downloadingServiceProvider) =>
                    downloadingServiceProvider.downloadingStatus,
                builder: (context, status, child) {
                  print("builded status widget 2");
                  return status == "Downloaded Successfully"
                      ? TextButton(
                          onPressed: () {
                            OpenFile.open(Provider.of<DownloadingService>(
                                    context,
                                    listen: false)
                                .filePath);
                          },
                          child: Text("Open File"))
                      : Container();
                },
              ),
              SizedBox(
                height: 180,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
