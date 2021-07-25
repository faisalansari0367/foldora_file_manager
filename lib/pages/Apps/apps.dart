import 'dart:io';

import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/LeadingIcon.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;

import '../../sizeConfig.dart';

class Apps extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  var apps = [];
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<>(context);
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        height: Responsive.height(100),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: FileUtils.getAllLocalApps(),
                builder: (context, snapshot) {
                  final paths = snapshot.data;
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  apps = paths;
                  return ListView.builder(
                    itemCount: paths.length,
                    itemBuilder: (context, index) {
                      final app = File(paths[index]);
                      return MediaListItem(
                        data: app,
                        currentPath: app.path,
                        title: p.basename(app.path),
                        description: MediaUtils.description(app),
                        index: index,
                        ontap: () {},
                        leading: LeadingIcon(data: app),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.all(),
                  elevation: 4,
                  primary: MyColors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: MyColors.teal),
                  ),
                  // padding: EdgeInsets.all(20),
                  minimumSize: Size(Responsive.width(100), Responsive.height(6)),
                ),
                onPressed: () async {
                  for (final app in apps) {
                    await OpenFile.open(app);
                  }
                },
                child: Text('Install All'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
