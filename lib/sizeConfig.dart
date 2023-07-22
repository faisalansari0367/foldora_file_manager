import 'package:flutter/material.dart';

class Responsive {
  static late double _screenWidth;
  static late double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;

      // _screenWidth = constraints.maxWidth;
      // _screenHeight = constraints.maxHeight;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
  }

  static double imageSize(num value) => value * Responsive.imageSizeMultiplier;
  static double width(num value) => value * Responsive.widthMultiplier;
  static double height(num value) => value * Responsive.heightMultiplier;
  static double text(num value) => value * Responsive.textMultiplier;
}

extension ResponsiveDouble on double {
  double get height => Responsive.height(this);
  double get width => Responsive.width(this);
  double get image => Responsive.imageSize(this);
  double get padding => Responsive.imageSize(this);
  double get text => Responsive.text(this);
}

extension ResponsiveInt on int {
  double get height => Responsive.height(this);
  double get width => Responsive.width(this);
  double get image => Responsive.imageSize(this);
  double get padding => Responsive.imageSize(this);
  double get text => Responsive.text(this);
}
