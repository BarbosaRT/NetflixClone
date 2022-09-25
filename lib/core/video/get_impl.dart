import 'package:netflix/core/video/video_interface.dart';
import 'package:netflix/core/video/vlc_impl.dart'
    if (dart.library.html) 'package:netflix/core/video/player_impl.dart'
    as video;

class GetImpl {
  VideoInterface getImpl() {
    return video.PlayerImpl();
  }
}
