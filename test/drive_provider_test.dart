import 'package:files/provider/drive_provider/drive_utils.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';

void main() {
  group('testing drive provider navrail', () {
    final testData = DriveUtils.testdata;
    final firstItem = testData.first;
    final secondItem = testData.elementAt(1);
    final thirdItem = testData.elementAt(2);
    test('add first item to navRail', () {
      DriveUtils.navigationAddOrRemove(firstItem.name, firstItem.id);
      expect(firstItem, DriveUtils.list.first);
      expect(DriveUtils.selectedIndex, 0);
    });

    test('add second item to navRail', () {
      DriveUtils.navigationAddOrRemove(secondItem.name, secondItem.id);
      expect(secondItem, DriveUtils.list.elementAt(1));
      expect(DriveUtils.selectedIndex, 1);
    });
    // if element is already in there do not add it again.
    test('should not add item if already there', () {
      DriveUtils.navigationAddOrRemove(firstItem.name, firstItem.id);
      expect(DriveUtils.list.where((element) => element == firstItem).length, 1);
      expect(DriveUtils.selectedIndex, 0);
    });

    test('add thrid item to navRail', () {
      DriveUtils.navigationAddOrRemove(thirdItem.name, thirdItem.id);
      expect(thirdItem, DriveUtils.list.elementAt(2));
      expect(DriveUtils.selectedIndex, 2);
    });

    // test('Go back once', () {
    //   DriveUtils.navigationAddOrRemove(secondItem.name, secondItem.id, goBack: true);
    //   expect(DriveUtils.list.length, 3);
    //   expect(DriveUtils.selectedIndex, 1);
    // });
    // test('Go back twice', () {
    //   DriveUtils.navigationAddOrRemove(secondItem.name, secondItem.id, goBack: true);
    //   DriveUtils.navigationAddOrRemove(secondItem.name, secondItem.id, goBack: true);

    //   expect(DriveUtils.list.length, 3);
    //   expect(DriveUtils.selectedIndex, 0);
    // });

    // test('Go to index 1', () {
    //   DriveUtils.navigationAddOrRemove(secondItem.name, secondItem.id);
    //   // DriveUtils.navigationAddOrRemove(thirdItem.name, thirdItem.id);

    //   expect(DriveUtils.list.length, 3);
    //   expect(DriveUtils.selectedIndex, 1);
    // });

    test('change last folder', () {
      DriveUtils.selectedIndex = DriveUtils.selectedIndex - 1;
      final item = DriveUtils.testdata.elementAt(3);
      DriveUtils.navigationAddOrRemove(item.name, item.id);
      expect(DriveUtils.list.last, item);
      expect(DriveUtils.list.length, 3);
      expect(DriveUtils.selectedIndex, 2);
    });
  });

  // GO back
}
