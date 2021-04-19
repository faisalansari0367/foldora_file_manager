import 'package:files/provider/OperationsProvider.dart';
import 'package:files/widgets/BottomNavy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/CustomDialog.dart';
import 'dart:io';
import '../sizeConfig.dart';

class OperationsUtils {
  static const Widget finishedIcon = Icon(Icons.check, color: Colors.white);

  static final _size = 12.8 * Responsive.widthMultiplier;

  static Widget customFAB(Widget child, {Function ontap}) {
    var inkWell = InkWell(
      onTap: ontap,
      child: CircleAvatar(
        radius: 7.0 * Responsive.widthMultiplier,
        backgroundColor: const Color(0xFF63cb99),
        child: child,
      ),
    );

    return inkWell;
  }

  static final _cpi = Selector<Operations, double>(
    selector: (_, value) => value.progress,
    builder: (_, value, __) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.teal[300]),
        value: value / 100,
      );
    },
  );

  static final _text = Selector<Operations, double>(
    selector: (_, value) => value.progress,
    builder: (_, value, __) {
      return Text(
        value.toStringAsFixed(0),
        style: TextStyle(color: Colors.white),
      );
    },
  );

  static Widget copyProgress() {
    return Stack(
      key: UniqueKey(),
      alignment: AlignmentDirectional.center,
      children: [
        customFAB(_text),
        Container(
          height: _size,
          width: _size,
          child: _cpi,
        )
      ],
    );
  }

  static bottomNavigation() {
    return Selector<Operations, bool>(
      selector: (_, value) => value.showBottomNavbar,
      builder: (context, value, child) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: value
              ? Container(
                  child: BottomNavy(),
                  width: double.infinity,
                  key: UniqueKey(),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                  key: UniqueKey(),
                ),
          transitionBuilder: (child, animation) => SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, 1.0),
              end: Offset(0.0, 0.0),
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  static myDialog(BuildContext context,
      {FileSystemEntity item, @required String eventName, String path}) async {
    return await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        item: item,
        eventName: eventName,
      ),
    );
  }
}
