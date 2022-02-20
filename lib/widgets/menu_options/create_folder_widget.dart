import 'package:files/decoration/my_decoration.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import '../my_elevated_button.dart';

class CreateFolder extends StatelessWidget {
  final void Function(String) onChanged;
  final void Function() onPressed;
  final String buttonText;
  final String hintText;
  const CreateFolder({Key key, this.onChanged, this.hintText, this.onPressed, this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 3.height),
          TextField(
            autofocus: true,
            cursorColor: MyColors.appbarActionsColor,
            cursorRadius: MyDecoration.circularRadius,
            onChanged: onChanged,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: MyColors.appbarActionsColor,
                  fontSize: 1.8.text,
                ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xff2e2f42),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.padding),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade300),
              hintText: hintText ?? 'Folder name',
            ),
          ),
          SizedBox(
            height: 2.height,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5.padding,
                    color: MyColors.darkGrey,
                    spreadRadius: 3.padding,
                  ),
                ],
              ),
              child: MyElevatedButton(
                text: buttonText ?? 'Create folder',
                onPressed: onPressed,
              ),
            ),
          ),
          // SizedBox(height: 2.height),
        ],
      ),
    );
  }
}
