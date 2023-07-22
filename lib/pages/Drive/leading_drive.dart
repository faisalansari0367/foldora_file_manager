import 'package:cached_network_image/cached_network_image.dart';
import 'package:files/pages/Drive/show_selected_icon.dart';
import 'package:files/provider/drive_provider/drive_downloader_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class LeadingDrive extends StatelessWidget {
  final String? extension, iconLink, id;
  final bool isSelected;
  final void Function()? onTap;

  const LeadingDrive({
    Key? key,
    required this.extension,
    this.iconLink,
    this.id,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShowSelectedIcon(
            isSelected: isSelected,
            child: Container(
              height: 10.image,
              width: 10.image,
              decoration: BoxDecoration(
                color: MyColors.darkGrey,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: CachedNetworkImage(
                  imageUrl: iconLink!,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      margin: EdgeInsets.all(1.image),
                      height: 2.image,
                      width: 2.image,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Selector<DriveDownloader, double?>(
            selector: selector,
            builder: (context, value, child) {
              return CircularProgressIndicator(
                color: MyColors.teal,
                value: value,
                strokeWidth: 2,
              );
            },
          ),
        ],
      ),
    );
  }

  double? selector(_, value) {
    var map;
    for (var item in value.queue) {
      if (item['id'] == id) {
        map = item;
        break;
      }
    }
    if (map == null) return 0.0;
    final percent = map['percent'] == 0.0 ? null : map['percent'] / 100;
    return percent;
  }
}
