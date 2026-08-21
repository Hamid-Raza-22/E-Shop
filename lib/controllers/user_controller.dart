import 'package:get/get.dart';

import '../models/user_model.dart';

/// In-memory profile store shared by the profile and edit-profile screens.
class UserController extends GetxController {
  UserController();

  static UserController get to => Get.find<UserController>();

  /// Preset avatars used by the edit-profile picker.
  ///
  /// Picking an image from the device gallery/camera would require the
  /// `image_picker` plugin, which is NOT currently a dependency of this
  /// project, so a preset list is used instead of faking a platform API.
  static const List<String> avatarOptions = [
    "https://i.imgur.com/IXnwbLk.png",
    "https://i.imgur.com/tXyOMMG.png",
    "https://i.imgur.com/h2LqppX.png",
    "https://i.imgur.com/dbbT6PA.png",
  ];

  UserModel _user = const UserModel(
    name: "Sepide",
    email: "theflutterway@gmail.com",
    phone: "+1 202 555 0134",
    imageSrc: "https://i.imgur.com/IXnwbLk.png",
  );

  UserModel get user => _user;

  /// Named `updateProfile` (not `update`) because `GetxController.update()` is
  /// the rebuild trigger and cannot be overloaded.
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? imageSrc,
  }) {
    _user = _user.copyWith(
      name: name,
      email: email,
      phone: phone,
      imageSrc: imageSrc,
    );
    update();
  }
}
