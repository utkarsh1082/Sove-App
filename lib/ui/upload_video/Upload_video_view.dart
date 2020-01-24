import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:video_player/video_player.dart';

class UploadVideoView extends StatefulWidget {
  static List<String> downloadURLList;

  @override
  _UploadVideoViewState createState() =>
      _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {

  File _video;
  StorageTaskSnapshot _taskSnapshot;
  StorageUploadTask _uploadTask;

  void getImage() async {
    File videoFile = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _video = videoFile;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(UploadVideoView.downloadURLList);
    if (UploadVideoView.downloadURLList == null) {
      UploadVideoView.downloadURLList = [];
    }
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/homePage');
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Upload Video"), centerTitle: false),
          body: Builder(
              builder: (ctx) => SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: MaterialButton(
                              onPressed: () async {
                                if (_video.lengthSync() < (20 * 1000000)) {
                                  FirebaseStorage firebaseStorage =
                                      FirebaseStorage.instance;
                                  StorageReference storageRef =
                                      firebaseStorage.ref();
                                  StorageReference storageRefName = storageRef
                                      .child('${Path.basename(_video.path)}');
                                  _uploadTask = storageRefName.putFile(_video);
                                  if (_uploadTask.isInProgress == true) {
                                    Scaffold.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Video has started uploading...',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  _taskSnapshot = await _uploadTask.onComplete;
                                  print(_taskSnapshot.bytesTransferred);
                                  if (_taskSnapshot.bytesTransferred ==
                                      _taskSnapshot.totalByteCount) {
                                    Scaffold.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Video is uploaded',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Scaffold.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Video uploading failed',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  String url = await storageRefName.getDownloadURL();
                                  setState(() {
                                    UploadVideoView.downloadURLList.add(url);
                                    print(url);
                                  });
                                } else {
                                  Scaffold.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Video size limit exceeded!\n Please limit your video size to 20MB',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text("Upload Video"),
                              elevation: 3.0,
                              color: Colors.grey),
                        ),
                        Container(
                            child: _video == null
                                ? FittedBox(child: Text("No Video Found"))
                                : FittedBox(
                                    fit: BoxFit.contain,
                                    child: mounted
                                        ? Chewie(
                                            controller: ChewieController(
                                                videoPlayerController:
                                                    VideoPlayerController.file(
                                                        _video)
                                                      ..initialize(),
                                                aspectRatio: 16 / 9,
                                                autoPlay: false,
                                                looping: false),
                                          )
                                        : Container(),
                                  ))
                      ],
                    ),
                  )),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                getImage();
              },
              child: Icon(Icons.video_library)),
        ));
  }
}
