import 'package:flutter/foundation.dart';
import 'package:netflix/src/features/profile/controllers/profile_model.dart';

class ProfileController extends ChangeNotifier {
  final List<ProfileModel> _profiles = [];
  List<ProfileModel> get profiles => _profiles;
  int selected = 0;

  void start() {
    if (_profiles == []) {
      return;
    }
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_1.jpeg',
      name: 'amog us',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_1.jpeg',
      name: 'sus',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_2.png',
      name: 'test',
    ));
    notifyListeners();
  }

  void select(int index) {
    selected = index;
    notifyListeners();
  }
}
