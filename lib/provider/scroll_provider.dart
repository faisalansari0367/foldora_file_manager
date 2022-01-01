import 'package:flutter/foundation.dart';

import '../sizeConfig.dart';

/// We use this provider for controlling navigationRail for controlling bottomAppBar

class ScrollProvider extends ChangeNotifier {
  double appbarSize = 0 * Responsive.heightMultiplier;
  bool navRail = false;

  void scrollListener(double size) {
    appbarSize = size.height;
    notifyListeners();
  }

  double scrolledPixels = 0.0;
  void pixelsScrolled(double value) {
    scrolledPixels = value;
    notifyListeners();
  }
}
