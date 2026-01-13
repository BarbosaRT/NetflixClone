import 'package:oldflix/core/video/video_interface.dart';
import 'package:oldflix/core/video/media_kit_impl.dart' as video;
//import 'package:oldflix/core/video/youtube_impl.dart';

class GetImpl {
  VideoInterface getImpl({int id = 0, bool isOnline = false}) {
    // if (isOnline && kIsWeb) {
    //   return YoutubeImpl();
    // }
    return video.PlayerImpl(id: id);
  }
}
