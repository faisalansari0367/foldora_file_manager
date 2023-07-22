import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/Drive/drive_list_item_placeholder.dart';
import 'package:flutter/material.dart';

class ListViewSwitcher extends StatelessWidget {
  final bool isLoading;
  final Widget? child, placeholder;

  const ListViewSwitcher({
    Key? key,
    this.isLoading = false,
    required this.child,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: MyDecoration.duration,
      layoutBuilder: (widget, children) {
        return widget!;
      },
      child: isLoading ? placeholder ?? DriveListItemPlaceholder() : child,
    );
  }
}
