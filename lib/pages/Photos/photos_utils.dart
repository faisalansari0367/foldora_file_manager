import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class PhotosUtils {
  static Future<void> setWallpaper(File file) async {
    final homeScreen = WallpaperManagerFlutter.HOME_SCREEN; //Choose screen type
    final wm = WallpaperManagerFlutter();
    await wm.setwallpaperfromFile(file, homeScreen);
    await Fluttertoast.showToast(msg: 'Wallpaper Applied');
  }
}
