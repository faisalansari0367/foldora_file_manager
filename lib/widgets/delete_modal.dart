import 'dart:developer';
import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

import '../sizeConfig.dart';
import 'LeadingIcon.dart';
import 'MediaListItem.dart';
import 'MyAppBar.dart';

class ModalSheet {
  static Future<void> deleteModal({
    BuildContext context,
    List<FileSystemEntity> list,
    void Function() onPressed,
  }) async {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          final operations = Provider.of<OperationsProvider>(context, listen: true);
          final myProvider = Provider.of<MyProvider>(context, listen: false);

          final child = AnnotatedRegion(
            value: AppbarUtils.systemUiOverylay(
              systemNavigationBarColor: MyColors.darkGrey,
            ),
            child: DraggableScrollableSheet(
              maxChildSize: 0.9,
              initialChildSize: 0.7,
              builder: (context, scrollController) {
                log('rebuilding widget');
                return Container(
                  height: Responsive.height(100),
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.width(3)),
                    decoration: BoxDecoration(
                      color: MyColors.darkGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25),
                        topRight: const Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        // Container(
                        //   // padding: EdgeInsets.only(top: 50),
                        //   width: 40,
                        //   height: 5,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(16)),
                        //     color: Colors.grey[700],
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Text(
                              'Are you sure want to delete these files',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: operations.selectedMedia.length,
                            itemBuilder: (context, index) {
                              final data = operations.selectedMedia[index];
                              return MediaListItem(
                                index: index,
                                data: data,
                                trailing: IconButton(
                                  onPressed: () => operations.removeItem(data),
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey[700],
                                    size: Responsive.imageSize(5),
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
                        MyElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await operations.deleteFileOrFolder(context);
                            await myProvider.diskSpace();
                            myProvider.notify();
                            print('notified');
                          },
                          text: 'Delete Files',
                        ),
                        SizedBox(height: Responsive.height(1)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );

          return child;
        });
  }
}
