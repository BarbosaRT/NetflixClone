import 'package:flutter/foundation.dart';
import 'package:netflix/src/features/profile/controllers/profile_model.dart';

class ProfileController extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  List<ProfileModel> get profiles => _profiles;
  int selected = 1;

  void start() {
    if (_profiles == []) {
      return;
    }
    _profiles = [];
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_5.png',
      name: 'papai',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_6.png',
      name: 'amog us',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_3.png',
      name: 'mamae',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_1.jpeg',
      name: 'dog',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_4.png',
      name: 'infantil',
    ));
    notifyListeners();
  }

  void select(int index) {
    selected = index;
    notifyListeners();
  }
}
