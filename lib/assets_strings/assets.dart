import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;

class Assets {
  static final map = <String, String>{};
  static final assets = Directory('../../../assets');

  static void recursive(String path) {
    final dir = Directory(path);
    dir.list().listen(
      (event) {
        print(event);
        if (event is File) {
          final name = p.basenameWithoutExtension(event.path);
          map[name] = event.path;
        } else {
          recursive(event.path);
        }
      },
    );
  }

  static void init() async {
    recursive('./');
    log(map.toString());
    try {
      // await File('assets.json').writeAsString(map.toString());
    } catch (e) {
      print(e);
    }
  }
}
