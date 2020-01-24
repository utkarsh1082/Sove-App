import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sowe_app/ui/home_page/widgets/VideoListItem.dart';
import 'package:sowe_app/ui/upload_video/Upload_video_view.dart';
import 'package:video_player/video_player.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  List<VideoListItem> constructList() {
    List<VideoListItem> items=[];
    if (UploadVideoView.downloadURLList != null) {
      print("not null ${UploadVideoView.downloadURLList}");
      for(int i=0;i<UploadVideoView.downloadURLList.length;i++){
        print("indise ");
        var item =new VideoListItem(
            ChewieController(
                videoPlayerController: VideoPlayerController.network(UploadVideoView.downloadURLList[i])
                  ..initialize(),
                aspectRatio: 16 / 9,
                autoPlay: false,
                looping: false), () async {
          FirebaseStorage firebaseStorage = FirebaseStorage.instance;
          StorageReference storageRef = firebaseStorage.ref();
          print("delete");
          var _deleteTask = await storageRef.child(UploadVideoView.downloadURLList[i]).delete();
        });
        items.add(item);
      }

      UploadVideoView.downloadURLList.map((url) {
        print("indise ");
        items.add(new VideoListItem(
            ChewieController(
                videoPlayerController: VideoPlayerController.network(url)
                  ..initialize(),
                aspectRatio: 16 / 9,
                autoPlay: false,
                looping: false), () async {
          FirebaseStorage firebaseStorage = FirebaseStorage.instance;
          StorageReference storageRef = firebaseStorage.ref();
          print("delete");
          var _deleteTask = await storageRef.child(url).delete();
        }));
      });
    }
    if(items!=null)
    print('items func ${items.length}');
    return items;
  }

  @override
  Widget build(BuildContext context) {
    List<VideoListItem> items = constructList();

    UploadVideoView.downloadURLList != null
        ? print("Home Page Text ${UploadVideoView.downloadURLList}")
        : print("List is null");
    items != null
        ? print("items ${items.length}")
        : print("items is null");

    if(items==null){
      return Scaffold(
        appBar: AppBar(
            title: Text("Sowe Apps"),
            centerTitle: false,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 10.0, 0),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: RaisedButton(
                    child: Text('Upload Video'),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/uploadVideo');
                    },
                  ),
                ),
              )
            ]),
        body: Container(child: Text("No video uploaded"),),
      );
    }
    return Scaffold(
      appBar: AppBar(
          title: Text("Sowe Apps"),
          centerTitle: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0, 10.0, 0),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: RaisedButton(
                  child: Text('Upload Video'),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/uploadVideo');
                  },
                ),
              ),
            )
          ]),
      body: new ListView(
        children: items.map((item) {
          return new Container(
            margin: new EdgeInsets.only(bottom: 20.0),
            child: new Card(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Chewie(controller: item.controller),
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton.icon(
                      label: Text('Delete Video'),
                      icon: Icon(Icons.delete),
                      onPressed: item.delete,
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
