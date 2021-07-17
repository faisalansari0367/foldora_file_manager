import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/OperationsUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FAB extends StatefulWidget {
  final String path;
  const FAB({this.path});

  @override
  _FABState createState() => _FABState();
}

class _FABState extends State<FAB> {
  static Widget addIcon = Icon(Icons.add, color: Colors.white, key: UniqueKey());
  final Widget close = OperationsUtils.copyProgress();

  @override
  Widget build(BuildContext context) {
    final ontap = () => OperationsUtils.myDialog(context, eventName: "Create", path: widget.path);
    final Widget open = OperationsUtils.customFAB(addIcon, ontap: ontap);

    return Selector<OperationsProvider, bool>(
      selector: (_, value) => value.operationIsRunning,
      builder: (_, value, __) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 300),
          firstChild: open,
          secondChild: close,
          crossFadeState: value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        );
      },
    );
  }
}
