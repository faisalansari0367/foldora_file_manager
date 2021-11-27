import 'package:files/helpers/date_format_helper.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class Description extends StatelessWidget {
  final Color textColor;
  final String bytes;
  final DateTime createdTime;
  const Description({Key key, this.textColor, this.bytes, this.createdTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasSize = bytes != null;

    final size =
        hasSize ? '| ${FileUtils.formatBytes(int.parse(bytes), 2)}' : '';
    var text = '${DateFormatter.formatDate(createdTime)} $size';
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 1.4 * Responsive.textMultiplier,
        color: textColor ?? Colors.grey[700],
      ),
    );
  }
}
