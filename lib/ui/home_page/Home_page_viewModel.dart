import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sowe_app/ui/home_page/widgets/VideoListItem.dart';
import 'package:sowe_app/ui/upload_video/Upload_video_view.dart';
import 'package:video_player/video_player.dart';

class HomePageViewModel {

  static List<VideoListItem> items;

  void constructList() {
    if(items==null)
        items=[];
    if (UploadVideoView.downloadURLList != null) {
      for (int i = items.length; i < UploadVideoView.downloadURLList.length; i++) {
        var item = new VideoListItem(
            ChewieController(
                videoPlayerController: VideoPlayerController.network(
                    UploadVideoView.downloadURLList[i])
                  ..initialize(),
                aspectRatio: 16 / 9,
                autoPlay: false,
                looping: false), () async {
          FirebaseStorage firebaseStorage = FirebaseStorage.instance;
          StorageReference storageRef = firebaseStorage.ref();
          print("delete");
          var _deleteTask = await storageRef
              .child(UploadVideoView.downloadURLList[i])
              .delete();
          items.removeAt(i);
        });
        items.add(item);
      }
    }
  }
}
