import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAnnotatedRegion extends StatelessWidget {
  final Brightness brightness;
  final Color? systemNavigationBarColor, statusBarColor;
  final Widget? child;
  const MyAnnotatedRegion({
    Key? key,
    this.brightness = Brightness.light,
    this.systemNavigationBarColor,
    this.statusBarColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: systemNavigationBarColor ?? Colors.transparent,
        statusBarColor: statusBarColor ?? Colors.transparent,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarDividerColor: Colors.transparent,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarIconBrightness: brightness,
      ),
      child: child!,
    );
  }
}
