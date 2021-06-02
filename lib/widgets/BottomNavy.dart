import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../sizeConfig.dart';
import 'package:path/path.dart' as p;

import 'LeadingIcon.dart';

class BottomNavy extends StatefulWidget {
  // final String path;
  // const BottomNavy({this.path});
  @override
  _BottomNavyState createState() => _BottomNavyState();
}

class _BottomNavyState extends State<BottomNavy> {
  _showModalBottomSheet() {
    // final provider = Provider.of<MyProvider>(context, listen: false);
    return showModalBottomSheet(
        backgroundColor: Color(0xFF737373),
        enableDrag: true,
        // barrierColor: Colors.white,
        elevation: 4,
        // isDismissible: true,
        // isScrollControlled: true,
        context: context,
        builder: (context) {
          final operations = Provider.of<Operations>(context, listen: true);
          return Container(
            color: Color(0xFF737373),
            width: double.infinity,
            child: Container(
              // padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColors.darkGrey,
                // color: MyColors.whitish,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
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
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      // Icon(
                      //   Icons.more_horiz,
                      //   color: MyColors.whitish,
                      // ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: operations.selectedMedia.length,
                      itemBuilder: (context, index) {
                        final data = operations.selectedMedia[index];
                        return MediaListItem(
                          index: index,
                          data: data,
                          // ontap: () => provider.ontap(data),
                          trailing: IconButton(
                            onPressed: () =>
                                operations.selectedMedia.remove(data),
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[700],
                            ),
                          ),
                          title: p.basename(data.path),
                          currentPath: data.path,
                          description: MediaUtils.description(data,
                              textColor: Colors.grey[600]),
                          leading: LeadingIcon(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
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
                    onPressed: () {
                      operations.deleteFileOrFolder();
                      Navigator.of(context).pop();
                      // Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      // padding: EdgeInsets.all(),
                      elevation: 4,
                      primary: MyColors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: MyColors.teal),
                      ),
                      minimumSize:
                          Size(Responsive.width(85), Responsive.height(6)),
                    ),
                    child: Text('Delete'),
                  ),
                  SizedBox(height: Responsive.height(1)),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Operations>(context, listen: true);
    final myProvider = Provider.of<MyProvider>(context, listen: true);
    final currentPath = myProvider.data[myProvider.currentPage].currentPath;
    final _paste = () {
      provider.copySelectedItems(currentPath);
      provider.ontapCopy();
    };

    final IconButton copyPasteSwitcher = provider.showCopy
        ? IconButton(
            splashColor: Colors.teal[300],
            icon: Icon(Icons.content_copy, color: Colors.teal),
            onPressed: () => provider.ontapCopy(),
            key: ValueKey(1),
          )
        : IconButton(
            icon: Icon(Icons.paste, color: Colors.blue),
            splashColor: Colors.red[300],
            onPressed: _paste,
            key: ValueKey(2),
          );

    final sizedBox = SizedBox(width: 0.2 * Responsive.widthMultiplier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          sizedBox,
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: copyPasteSwitcher,
          ),
          IconButton(
            splashColor: Colors.red[300],
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _showModalBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.create, color: Colors.amber),
            onPressed: () {
              provider.renameFSE(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.content_cut, color: Colors.cyan),
            onPressed: () => provider.move(currentPath),
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.cyan),
            onPressed: () => Share.shareFiles(provider.sharePaths()),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.teal),
            onPressed: _showModalBottomSheet,
          ),
          sizedBox
        ],
      ),
    );
  }
}
