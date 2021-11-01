import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'delete_modal.dart';

class BottomNavy extends StatefulWidget {
  // final String path;
  // const BottomNavy({this.path});
  @override
  _BottomNavyState createState() => _BottomNavyState();
}

class _BottomNavyState extends State<BottomNavy> {
  Future<void> onPressedDeleteButton(context) async {
    final operations = Provider.of<OperationsProvider>(context, listen: false);
    final myProvider = Provider.of<MyProvider>(context, listen: false);

    await operations.deleteFileOrFolder(context);
    Navigator.of(context).pop();
    myProvider.notify();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OperationsProvider>(context, listen: true);
    final myProvider = Provider.of<MyProvider>(context, listen: true);
    final currentPath = myProvider.data[myProvider.currentPage].currentPath;
    const color = Colors.black;

    final _paste = () async {
      await provider.copySelectedItems(currentPath, myProvider.notify);
      provider.ontapCopy();
      // myProvider.notify();
    };

    final copyPasteSwitcher = provider.showCopy
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
    print('bottom navigation rebuilding');
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(16),
        //   topRight: Radius.circular(16),
        // ),
        color: MyColors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
          )
        ],
      ),
      child: Row(
        // key: UniqueKey(),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.min,
        children: AnimationConfiguration.toStaggeredList(
          delay: const Duration(milliseconds: 50),
          duration: const Duration(milliseconds: 300),
          childAnimationBuilder: (widget) => SlideAnimation(
            curve: Curves.fastOutSlowIn,
            verticalOffset: 50.0,
            child: FadeInAnimation(
              curve: Curves.fastOutSlowIn,
              delay: Duration(milliseconds: 50),
              child: widget,
            ),
          ),
          children: [
            // sizedBox,
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: copyPasteSwitcher,
            ),
            IconButton(
              splashColor: Colors.red[300],
              icon: Icon(Icons.delete, color: color),
              onPressed: () => ModalSheet.deleteModal(
                context: context,
                list: provider.selectedMedia,
                // onPressed: () => onPressedDeleteButton(context),
              ),
            ),
            IconButton(
              icon: Icon(Icons.create, color: color),
              onPressed: () async {
                await provider.renameFSE(context);
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
      ),
    );
  }
}
