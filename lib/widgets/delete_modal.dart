import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

import '../sizeConfig.dart';
import 'LeadingIcon.dart';
import 'MediaListItem.dart';

Future<void> deleteModal({
  BuildContext context,
  List<FileSystemEntity> list,
  Function onPressed,
}) async {
  print(list);
  return await showModalBottomSheet(
    backgroundColor: Color(0xFF737373),
    enableDrag: true,
    elevation: 4,
    context: context,
    builder: (context) {
      final operations = Provider.of<OperationsProvider>(context, listen: true);
      final myProvider = Provider.of<MyProvider>(context, listen: false);

      return Container(
        color: Color(0xFF737373),
        width: double.infinity,
        margin: EdgeInsets.all(Responsive.width(90.0)),
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.darkGrey,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(32),
              topRight: const Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Delete files',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: MyColors.whitish,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final data = list[index];
                    return MediaListItem(
                      index: index,
                      data: data,
                      // ontap: () => provider.ontap(data),
                      trailing: IconButton(
                        onPressed: () => operations.selectedMedia.remove(data),
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[700],
                        ),
                      ),
                      title: p.basename(data.path),
                      currentPath: data.path,
                      description: MediaUtils.description(data, textColor: Colors.grey[600]),
                      leading: LeadingIcon(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white10,
                        ),
                        data: data,
                        iconColor: Colors.white38,
                      ),
                      selectedColor: MyColors.darkGrey,
                      textColor: Colors.grey[400],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: onPressed ??
                    () async {
                      await operations.deleteFileOrFolder(context);
                      Navigator.of(context).pop();
                      // for notifing myProvider so user can we notified
                      myProvider.notify();
                    },
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.all(),
                  elevation: 4,
                  primary: MyColors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: MyColors.teal),
                  ),
                  minimumSize: Size(Responsive.width(85), Responsive.height(6)),
                ),
                child: Text('Delete'),
              ),
              SizedBox(height: Responsive.height(1)),
            ],
          ),
        ),
      );
    },
  );
}
