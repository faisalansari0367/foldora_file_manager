import 'package:storage_details/storage_details.dart';

class Data {
  String path;
  String currentPath;
  int free;
  int used;
  int total;
  List<String> navItems;

  Data({
    this.path,
    this.currentPath,
    this.used,
    this.free,
    this.navItems,
    this.total,
  });

  static List<Data> storageToData(List<Storage> list) {
    return List.generate(list.length, (index) {
      final Storage storage = list[index];
      return Data(
        currentPath: storage.path,
        free: storage.free,
        navItems: <String>[storage.path],
        path: storage.path,
        total: storage.total,
        used: storage.used,
      );
    });
  }

  @override
  bool operator ==(Object other) {
    // currentPath == other.currentPath
    return super == other;
  }
}
