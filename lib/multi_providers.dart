import 'package:files/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/LeadingIconProvider.dart';
import 'provider/OperationsProvider.dart';
import 'provider/StoragePathProvider.dart';
import 'provider/drive_provider.dart';
import 'provider/scroll_provider.dart';

class AddProviders extends StatelessWidget {
  final Widget child;
  const AddProviders({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyProvider>(
          create: (context) => MyProvider(),
        ),
        ChangeNotifierProvider<StoragePathProvider>(
          create: (context) => StoragePathProvider(),
        ),
        ChangeNotifierProvider<IconProvider>(
          create: (context) => IconProvider(),
        ),
        ChangeNotifierProvider<OperationsProvider>(
          create: (context) => OperationsProvider(),
        ),
        ChangeNotifierProvider<ScrollProvider>(
          create: (context) => ScrollProvider(),
        ),
        ChangeNotifierProvider<DriveProvider>(
          create: (context) => DriveProvider(),
        ),
      ],
      child: child,
    );
  }
}
