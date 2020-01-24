import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sowe_app/ui/home_page/Home_page_view.dart';
import 'package:sowe_app/ui/upload_video/Upload_video_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sowe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: <String, WidgetBuilder>{
        '/homePage': (BuildContext context) => HomePageView(),
        '/uploadVideo': (BuildContext context) => UploadVideoView()
      },
      home: HomePageView(),
    );
  }
}
