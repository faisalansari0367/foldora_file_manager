import 'package:files/utilities/OperationsUtils.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/ListBuilder.dart';
import 'package:flutter/material.dart';

class ListFolders extends StatelessWidget {
  final String path;
  ListFolders({this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(backgroundColor: Colors.transparent),
      body: DirectoryLister(path: path),
      bottomNavigationBar: OperationsUtils.bottomNavigation(),
      floatingActionButton: FAB(),
    );
  }
}
