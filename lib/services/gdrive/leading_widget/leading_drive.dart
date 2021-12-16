
import 'package:cached_network_image/cached_network_image.dart';
import 'package:files/decoration/my_decoration.dart';
import 'package:files/provider/drive_downloader_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../sizeConfig.dart';

class LeadingDrive extends StatelessWidget {
  final String extension, iconLink, id;
  const LeadingDrive(
      {Key key, @required this.extension, this.iconLink, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: Responsive.imageSize(10),
          width: Responsive.imageSize(10),
          decoration: BoxDecoration(
            color: MyColors.darkGrey,
            borderRadius: MyDecoration.borderRadius,
          ),
          child: FittedBox(
            child: CachedNetworkImage(
              imageBuilder: (context, imageProvider) {
                return Container(
                  margin: EdgeInsets.all(Responsive.imageSize(1)),
                  height: Responsive.imageSize(2),
                  width: Responsive.imageSize(2),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
              imageUrl: iconLink,
            ),
          ),
        ),
        Selector<DriveDownloader, double>(
          builder: (context, value, child) {
            return CircularProgressIndicator(
              color: MyColors.teal,
              value: value,
              strokeWidth: 2,
            );
          },
          selector: selector,
        ),
      ],
    );
  }

  double selector(_, value) {
    var map;
    for (var item in value.queue) {
      if (item['id'] == id) {
        map = item;
        break;
      }
    }
    if (map == null) return 0.0;
    final percent = map['percent'] == 0.0 ? null : map['percent'] /100;
    return percent;
  }
}
