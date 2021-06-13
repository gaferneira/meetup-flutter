import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';

executeAfterBuild(Function function) {
  WidgetsBinding.instance!.addPostFrameCallback((_) =>
      function
  );
}

snackBar(BuildContext context, String message, [bool isError = false]) {
  return SnackBar(
    content: Text(
      message,
      style: Theme.of(context).textTheme.bodyText1,
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
  );
}

Widget showRetry(String? error, Function() onPressed) {
  return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error ?? Strings.unknownError,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(Strings.retry),
            )
          ]
      )
  );
}