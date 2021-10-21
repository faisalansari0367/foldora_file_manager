import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'CopyUtils.dart';

class OperationIsolate {
  bool running = false;
  Isolate isolate;
  StreamController<Map<String, dynamic>> _streamController;
  Stream<Map<String, dynamic>> _stream;
  // ignore: unused_field
  SendPort _toIsolate;

  Future<Stream<Map<String, dynamic>>> operationsIsolate({
    List<FileSystemEntity> filesToCopy,
    String pathWhereToCopy,
  }) async {
    if (running) {
      return _stream;
    }
    running = true;
    var fromIsolate = ReceivePort();
    _streamController = StreamController<Map<String, dynamic>>();
    fromIsolate.listen((data) {
      // print(data is Map<String, dynamic>);
      if (data is bool) {
        _streamController.close();
      }
      if (data is SendPort) {
        _toIsolate = data;
      }
      if (data is Map<String, dynamic>) {
        _streamController.sink.add(data);
      }
    }, onDone: () {
      print('stream completed');
    });

    isolate = await Isolate.spawn(
      _update,
      IsolateCopyProgress(
          streamController: _streamController,
          filesToCopy: filesToCopy,
          pathWhereToCopy: pathWhereToCopy,
          sendPort: fromIsolate.sendPort),
    );
    return _streamController.stream;
  }

  void _update(IsolateCopyProgress utils) {
    var _toIsolate = ReceivePort();
    utils.sendPort.send(_toIsolate.sendPort);
    final stream = utils.copySelectedItems();
    stream.listen(
      (event) {
        print(event);
        if (event['progress'] == 100.0) {
          utils.sendPort.send(true);
        } else {
          // utils.streamController.sink.add(event);
          utils.sendPort.send(event);
        }
      },
    );

    // subscription.onDone(() {
    //   // if (progress == 100.0) ;
    //   print('progress is done');
    //   // subscription.cancel();
    // });

    // utils.copySelectedItems(map)
  }
}
