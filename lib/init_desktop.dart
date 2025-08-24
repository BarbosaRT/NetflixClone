import 'package:media_kit/media_kit.dart';

void init() async {
  //await FlutterNativeView.ensureInitialized();
  //useFlutterNativeView: io.Platform.isWindows
  MediaKit.ensureInitialized();
}
