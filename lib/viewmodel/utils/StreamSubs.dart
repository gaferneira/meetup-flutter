import 'dart:async';

class StreamSubs {

  List<StreamSubscription> list = <StreamSubscription>[];

  void add(StreamSubscription streamSubscription) {
    list.add(streamSubscription);
  }

  void cancelAll() {
    for (var streamSub in list) {
      streamSub.cancel();
    }
  }

}