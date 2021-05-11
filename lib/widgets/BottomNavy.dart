import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../sizeConfig.dart';

class BottomNavy extends StatefulWidget {
  // final String path;
  // const BottomNavy({this.path});
  @override
  _BottomNavyState createState() => _BottomNavyState();
}

class _BottomNavyState extends State<BottomNavy> {
  final Function _onPressed = () {};
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
            onPressed: () => provider.deleteFileOrFolder(),
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
            onPressed: _onPressed,
          ),
          sizedBox
        ],
      ),
    );
  }
}
