import 'package:flutter/cupertino.dart';

class DemoData {
  String fileType;
  String fileName;
  String fileUrl;

  DemoData(
      {@required this.fileType,
      @required this.fileName,
      @required this.fileUrl});
}

List<DemoData> data = [
  DemoData(
      fileType: "Image",
      fileName: "downloaded_image.jpg",
      fileUrl:
          "https://images.pexels.com/photos/3617500/pexels-photo-3617500.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260"),
  DemoData(
      fileType: "Gif",
      fileName: "downloaded_gif.gif",
      fileUrl:
          "https://blog.commlabindia.com/wp-content/uploads/2019/07/animated-gifs-corporate-training.gif"),
  DemoData(
      fileType: "Audio",
      fileName: "downloaded_audio.mp3",
      fileUrl:
          "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_2MG.mp3"),
  DemoData(
      fileType: "PDF",
      fileName: "downloaded_pdf.pdf",
      fileUrl:
          "https://sambazmusic.files.wordpress.com/2017/08/give-and-take.pdf"),
  DemoData(
      fileType: "Video",
      fileName: "downloaded_video.mp4",
      fileUrl:
          "https://instagram.fixc9-1.fna.fbcdn.net/v/t50.2886-16/152097162_798717411003259_2114393941703135529_n.mp4?_nc_ht=instagram.fixc9-1.fna.fbcdn.net&_nc_cat=107&_nc_ohc=cibwlACnlnoAX80mxmE&edm=APfKNqwAAAAA&ccb=7-4&oe=606A31C1&oh=be3a87e77dd78574275cb0f4af5e9ce5&_nc_sid=74f7ba")
];
