import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/core/video/media_kit_impl.dart' as video;
//import 'package:netflix/core/video/youtube_impl.dart';

class GetImpl {
  VideoInterface getImpl({int id = 0, bool isOnline = false}) {
    // if (isOnline && kIsWeb) {
    //   return YoutubeImpl();
    // }
    return video.PlayerImpl(id: id);
  }
}
