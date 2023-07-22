import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  final String? title;
  final bool value;
  final void Function(bool)? onChanged;
  const OptionItem({Key? key, this.title, this.value = false, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onChanged!(!value),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        overlayColor: MaterialStateProperty.all(MyColors.whitish),
        activeColor: MyColors.whitish,
        focusColor: MyColors.whitish,
      ),
      title: Text(
        title!,
        style: TextStyle(color: Colors.grey[300]),
      ),
    );
  }
}