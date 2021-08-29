import 'package:storage_details/storage_details.dart';
// import 'package:equatable/equatable.dart';

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
    if (other is Data &&
        runtimeType == other.runtimeType &&
        currentPath == other.currentPath &&
        path == other.path &&
        used == other.used &&
        free == other.free &&
        navItems == other.navItems &&
        total == other.total) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => super.hashCode;
}
