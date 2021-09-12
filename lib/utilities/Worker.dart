import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

class Worker {
  Worker() {
    _start();
  }

  Isolate _isolate;
  SendPort childSendPort;
  final _isReady = Completer<void>();
  Future<void> get isReady => _isReady.future;

  Future<void> _start() async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();

    _isolate =
        await Isolate.spawn(workerIsolate, receivePort.sendPort, onError: errorPort.sendPort);
    errorPort.listen(print);
    childSendPort = await receivePort.first;
    _isReady.complete();
  }

  static Future<void> workerIsolate(SendPort mainSendPort) async {
    final childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    await for (final message in childReceivePort) {
      final SendPort replyPort = message[1];

      try {
        final data = message[0];
        final bool isStream = data['isStream'];
        final Function function = data['fun'];
        final args = data['args'];
        if (isStream) {
          final stream = function(args);
          stream.listen((event) {
            replyPort.send(event);
          }, onDone: () {
            print('done');
            replyPort.send('done');
          });
        } else {
          final result = await function(args);
          replyPort.send(result);
        }
      } catch (e) {
        log('ERROR FROM ISOLATE: $e');
      }
    }
  }

  Future<dynamic> doWork(Function function, args, {isStream = false}) async {
    await isReady;
    final responsePort = ReceivePort();
    final map = {'fun': function, 'args': args, 'isStream': isStream};
    childSendPort.send([map, responsePort.sendPort]);
    // responsePort.listen((message) { }, on)
    final response = await responsePort.first;

    if (response is Exception) {
      throw response;
    } else if (response is StackTrace) {
      return response;
    } else {
      return response;
    }
  }

  Future<dynamic> doOperation(Function function, args, {isStream = true}) async {
    await isReady;
    final responsePort = ReceivePort();
    final map = {'fun': function, 'args': args, 'isStream': isStream};
    childSendPort.send([map, responsePort.sendPort]);
    return responsePort;
  }

  void stop() {
    _isolate.kill();
  }
}
