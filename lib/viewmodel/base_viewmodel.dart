import 'package:life_eazy/enums/viewstate.dart';
import 'package:stacked/stacked.dart';

import '../enums/profile_image_state.dart';

class CustomBaseViewModel extends BaseViewModel
{
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }


  ProfileImageState _profileState = ProfileImageState.Idle;

  ProfileImageState get profileState => _profileState;

  void setProfileState(ProfileImageState viewState) {
    _profileState = viewState;
    notifyListeners();
  }
}
