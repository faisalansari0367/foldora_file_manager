import 'dart:io';

import 'package:files/decoration/my_bottom_sheet.dart';
import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/provider_helpers.dart';
import 'package:files/provider/drive_provider/drive_deleter_provider.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';

class DriveFab extends StatefulWidget {
  const DriveFab({Key? key}) : super(key: key);

  @override
  State<DriveFab> createState() => _DriveFabState();
}

class _DriveFabState extends State<DriveFab> {
  String folderName = '';
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MyColors.teal,
      onPressed: onPressedFAB,
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  Future<void> _createFolder() async {
    Navigator.pop(context);
    await MyBottomSheet.bottomSheet(
      context,
      child: Container(
        margin: EdgeInsets.all(5.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 3.height),
            TextField(
              cursorColor: MyColors.appbarActionsColor,
              cursorRadius: MyDecoration.circularRadius,
              onChanged: (v) => folderName = v,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: MyColors.appbarActionsColor,
                    fontSize: 1.8.text,
                  ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff2e2f42),
                contentPadding: EdgeInsets.symmetric(horizontal: 5.padding),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade300),
                hintText: 'Folder Name',
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
                  text: 'Create folder',
                  onPressed: () async {
                    final dir = Directory(folderName);
                    final drive = getProvider<DriveProvider>(context);
                    await drive.createDriveDir(dir);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // SizedBox(height: 2.height),
          ],
        ),
      ),
    );
  }

  Future<void> onPressedFAB() async {
    await MyBottomSheet.bottomSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 3.height),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Item(
                name: 'Folder',
                iconData: Icons.create_new_folder_outlined,
                onTap: _createFolder,
              ),
              _Item(
                name: 'Upload',
                iconData: Icons.upload_file_outlined,
              ),
              _Item(
                name: 'Delete',
                iconData: Icons.delete_outline_outlined,
                onTap: () async {
                  final deleter = getProvider<DriveDeleter>(context);
                  await deleter.deleteFiles();
                },
              ),
            ],
          ),
          SizedBox(height: 3.height),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final void Function()? onTap;
  final String? name;
  final IconData? iconData;
  const _Item({
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
