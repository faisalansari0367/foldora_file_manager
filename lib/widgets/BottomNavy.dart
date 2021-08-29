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
    return showModalBottomSheet(
      backgroundColor: Color(0xFF737373),
      enableDrag: true,
      elevation: 4,
      context: context,
      builder: (context) {
        final operations = Provider.of<OperationsProvider>(context, listen: true);
        final myProvider = Provider.of<MyProvider>(context, listen: false);

        return Container(
          // color: Color(0xFF737373),
          color: Colors.transparent,
          width: double.infinity,
          child: Container(
            // width: Responsive.widthMultiplier * 10,
            // margin: EdgeInsets.symmetric(horizontal: Responsive.width(3)),
            padding: EdgeInsets.symmetric(horizontal: Responsive.width(3)),
            decoration: BoxDecoration(
              color: MyColors.darkGrey,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
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
                      'Are you sure want to delete these files',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: MyColors.whitish,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
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
                        trailing: IconButton(
                          onPressed: () => operations.selectedMedia.remove(data),
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
                ElevatedButton(
                  onPressed: () async {
                    await operations.deleteFileOrFolder();
                    await myProvider.diskSpace();
                    Navigator.of(context).pop();
                    // for notifing myProvider so user can we notified
                    myProvider.notify();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    primary: MyColors.teal,
                    shadowColor: MyColors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side: BorderSide(color: MyColors.teal),
                    ),
                    minimumSize: Size(Responsive.width(87), Responsive.height(6)),
                  ),
                  child: Text(
                    'Delete Files',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: Responsive.height(1)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OperationsProvider>(context, listen: true);
    final myProvider = Provider.of<MyProvider>(context, listen: true);
    final currentPath = myProvider.data[myProvider.currentPage].currentPath;
    const color = Colors.black;
    final _paste = () async {
      await provider.copySelectedItems(currentPath);
      provider.ontapCopy();
      myProvider.notify();
    };

    final IconButton copyPasteSwitcher = provider.showCopy
        ? IconButton(
            splashColor: Colors.teal[300],
            icon: Icon(Icons.content_copy, color: color),
            onPressed: () => provider.ontapCopy(),
            key: ValueKey(1),
          )
        : IconButton(
            icon: Icon(Icons.paste, color: Colors.blue),
            splashColor: Colors.red[300],
            onPressed: _paste,
            key: ValueKey(2),
          );

    // final sizedBox = SizedBox(width: 0.2 * Responsive.widthMultiplier);

    return Container(
      color: MyColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.min,
        children: [
          // sizedBox,
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: copyPasteSwitcher,
          ),
          IconButton(
            splashColor: Colors.red[300],
            icon: Icon(Icons.delete, color: color),
            onPressed: _showModalBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.create, color: color),
            onPressed: () async {
              provider.renameFSE(context);
              myProvider.notify();
            },
          ),
          IconButton(
            icon: Icon(Icons.content_cut, color: color),
            onPressed: () {
              provider.move(currentPath);
              myProvider.notify();
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: color),
            onPressed: () => Share.shareFiles(provider.sharePaths()),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: color),
            onPressed: () {},
          ),
          // sizedBox
        ],
      ),
    );
  }
}
