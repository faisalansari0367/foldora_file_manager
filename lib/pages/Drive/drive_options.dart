import 'package:files/pages/Drive/my_bottom_sheet.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:flutter/material.dart';

class DrowdownOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        splashRadius: 25,
        icon: Icon(Icons.more_vert),
        color: Colors.grey[500],
        onPressed: () => MyBottomSheet.bottomSheet(
          context,
          child: MyAnnotatedRegion(
            systemNavigationBarColor: MyColors.darkGrey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  onTap: () {},
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  title: Text(
                    'Show All files',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  title: Text(
                    'Only show folders',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
