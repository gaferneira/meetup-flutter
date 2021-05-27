
class Response<ResultType> {
  ResponseState state;
  ResultType? data;
  String? exception;

  Response({required this.state, this.data, this.exception});

  static Response<ResultType> none<ResultType>() {
    return Response(state: ResponseState.NONE);
  }

  static Response<ResultType> loading<ResultType>() {
    return Response(state: ResponseState.LOADING);
  }

  static Response<ResultType> complete<ResultType>(ResultType data) {
    return Response(state: ResponseState.COMPLETE, data: data);
  }

  static Response<ResultType> error<ResultType>(String exception) {
    return Response(state: ResponseState.ERROR, exception: exception);
  }

  bool wasSuccessful() {
    return state == ResponseState.COMPLETE;
  }
}

enum ResponseState{
  NONE,
  LOADING,
  COMPLETE,
  ERROR
}