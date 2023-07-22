import 'package:files/helpers/provider_helpers.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:files/widgets/menu_options/option_item.dart';
import 'package:files/widgets/menu_options/options_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoMenuOptions extends StatelessWidget {
  const VideoMenuOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = getProvider<VideosProvider>(context);
    return DropdownOptions(
      children: [
        Selector<VideosProvider, bool>(
          builder: (context, value, child) => OptionItem(
            onChanged: provider.setShowInFolders,
            title: 'Show in folders',
            value: value,
          ),
          selector: (p0, p1) => p1.showInFolders,
        ),
      ],
    );
  }
}
