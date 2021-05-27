import 'dart:async';

class StreamSubs {

  List<StreamSubscription> list = <StreamSubscription>[];

  void add(StreamSubscription streamSubscription) {
    list.add(streamSubscription);
  }

  void addAll(List<StreamSubscription> streamSubscriptions) {
    list.addAll(streamSubscriptions);
  }

  void cancelAll() {
    for (var streamSub in list) {
      streamSub.cancel();
    }
  }

}