import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

class FAB extends StatefulWidget {
  final String path;
  final void Function() onPressed;
  final Widget child;
  const FAB({this.path, this.onPressed, this.child});

  @override
  _FABState createState() => _FABState();
}

class _FABState extends State<FAB> {
  // static Widget addIcon = Icon(Icons.add, color: Colors.white, key: UniqueKey());
  // final Widget close = OperationsUtils.copyProgress();

  @override
  Widget build(BuildContext context) {
    // final ontap = () => OperationsUtils.myDialog(context, eventName: 'Create', path: widget.path);
    // final open = OperationsUtils.customFAB(addIcon, ontap: ontap);

    final fab = FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: widget.onPressed,
      backgroundColor: MyColors.teal,
      child: widget.child ?? Icon(Icons.add, color: MyColors.white),
    );
    return fab;
    // return Selector<OperationsProvider, bool>(
    //   selector: (_, value) => value.operationIsRunning,
    //   builder: (_, value, __) {
    //     return AnimatedCrossFade(
    //       duration: Duration(milliseconds: 300),
    //       firstChild: open,
    //       secondChild: close,
    //       crossFadeState: value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    //     );
    //   },
    // );
  }
}
