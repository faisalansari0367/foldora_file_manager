import 'package:flutter/material.dart';

import 'sizeConfig.dart';

class SizeConfig extends StatelessWidget {
  final Widget? child;
  const SizeConfig({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {                                                                                                                                                                                                                                                        
            Responsive().init(constraints, orientation);
            return child!;
          },
        );
      },
    );
  }
}
