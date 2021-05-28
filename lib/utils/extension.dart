import 'package:flutter/material.dart';

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
              error ?? "Wasn't able to retrieve the data, please check your internet connection.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: Text("Retry"),
            )
          ]
      )
  );
}