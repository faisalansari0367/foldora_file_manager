class DriveNavRailItem {
  final String name;
  final String id;
  DriveNavRailItem({this.name, this.id});

  @override
  bool operator ==(Object other) {
    if (other is DriveNavRailItem &&
        runtimeType == other.runtimeType &&
        name == other.name &&
        id == other.id) {
      return true;
    } else {
      return false;
    }
  }
}
