import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

class OptionIcon extends StatelessWidget {
  final void Function()? onTap;
  final String? name;
  final IconData? iconData;
  const OptionIcon({
    Key? key,
    this.onTap,
    this.name,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: MyColors.appbarActionsColor!),
            ),
            child: Icon(
              iconData,
              color: MyColors.appbarActionsColor,
            ),
          ),
        ),
        SizedBox(height: 1.height),
        Text(name!, style: theme.textTheme.bodyText2),
      ],
    );
  }
}