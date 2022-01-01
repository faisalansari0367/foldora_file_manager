import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/widgets/menu_options/option_item.dart';
import 'package:files/widgets/menu_options/options_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriveMenuOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DriveProvider>(context, listen: false);
    return DropdownOptions(
      children: [
        Selector<DriveProvider, bool>(
          selector: (p0, p1) => p1.showAllFiles,
          builder: (context, value, child) {
            return OptionItem(
              onChanged: provider.setShowAllFiles,
              title: 'Show All Files',
              value: provider.showAllFiles,
            );
          },
        ),
      ],
    );
  }
}
