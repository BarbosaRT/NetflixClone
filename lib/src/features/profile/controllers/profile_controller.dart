import 'package:flutter/foundation.dart';
import 'package:oldflix/src/features/profile/controllers/profile_model.dart';

class ProfileController extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  List<ProfileModel> get profiles => _profiles;
  int selected = 1;

  void start() {
    if (_profiles.isNotEmpty) {
      return;
    }
    _profiles = [];
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_5.png',
      name: 'Papai',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_6.png',
      name: 'Capivara',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_3.png',
      name: 'Mamae',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_1.png',
      name: 'Irmão',
    ));
    _profiles.add(ProfileModel(
      icon: 'assets/images/profiles/image_4.png',
      name: 'Infantil',
    ));
    notifyListeners();
  }

  void select(int index) {
    selected = index;
    notifyListeners();
  }
}
