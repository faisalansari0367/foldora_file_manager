import 'package:files/pages/Drive/drive_nav_rail_item.dart';

class DriveUtils {
  static var selectedIndex = 0;
  static var list = <DriveNavRailItem>[DriveNavRailItem(name: 'Drive')];
  static final testdata = [
    DriveNavRailItem(id: '1', name: 'folder 1'),
    DriveNavRailItem(id: '2', name: 'folder 2'),
    DriveNavRailItem(id: '3', name: 'folder 3'),
    DriveNavRailItem(id: '4', name: 'folder 4'),
    DriveNavRailItem(id: '5', name: 'folder 5'),
    DriveNavRailItem(id: '6', name: 'folder 6'),
    DriveNavRailItem(id: '7', name: 'folder 7'),
    DriveNavRailItem(id: '8', name: 'folder 8'),
  ];

  static void navigationAddOrRemove(String name, String id) {
    final item = DriveNavRailItem(id: id, name: name);
    final itemExist = list.contains(item);
    if (itemExist) {
      selectedIndex = list.indexOf(item);
    } else {
      if (list.length > 2) list.removeRange(selectedIndex + 1, list.length);
      list.add(item);
      selectedIndex = list.indexOf(item);
    }
  }

  // else if (selectedIndex < list.length) {
  //     list.removeRange(selectedIndex, list.length);
  //     list.add(item);
  //     selectedIndex++;
  //   }
}
