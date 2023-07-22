import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/MyProvider.dart';
import '../utilities/MediaListItemUtils.dart';
import '../sizeConfig.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class CustomDialog extends StatefulWidget {
  final FileSystemEntity? item;
  final String? path;
  final String eventName;
  const CustomDialog({required this.item, required this.eventName, this.path});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  TextEditingController? _textController;

  @override
  void initState() {
    final text = widget.item == null ? null : p.basename(widget.item!.path);
    _textController = TextEditingController(text: text);
    super.initState();
  }

  @override
  void dispose() {
    _textController!.dispose();
    super.dispose();
  }

  var textStyle = TextStyle(color: Colors.grey[400]);

  var sizedBox = SizedBox(
    height: 2 * Responsive.heightMultiplier,
  );

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);

    final Widget child = Container(
      padding: EdgeInsets.all(5 * Responsive.imageSizeMultiplier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            style: textStyle,
            autofocus: true,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              labelText: 'Folder Name',
            ),
            controller: _textController,
            cursorRadius: Radius.circular(12),
          ),
          // actions: <Widget>[
          sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('Cancel'.toUpperCase(), style: textStyle),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                // splashColor: Colors.grey[200],
                child: Text(
                  widget.eventName.toUpperCase(),
                  style: textStyle,
                ),
                onPressed: () async {
                  final name = _textController!.text.trim();
                  if (widget.eventName == 'rename') {
                    await provider.rename(widget.item!, name);
                  } else {
                    final currentPath = provider.data[provider.currentPage].currentPath!;
                    await provider.createFileSystemEntity(currentPath, name);
                  }
                  _textController!.text = '';
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      ),
    );

    final dialog = Dialog(
      insetPadding: EdgeInsets.all(10),
      elevation: 5,
      insetAnimationCurve: Curves.easeInBack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: MediaUtils.backgroundColor,
      child: child,
    );

    return dialog;
  }
}
