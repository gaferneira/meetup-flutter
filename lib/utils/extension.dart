import 'package:flutter/material.dart';

executeAfterBuild(Function function) {
  WidgetsBinding.instance!.addPostFrameCallback((_) =>
      function
  );
}

showSnackBar(BuildContext context, String message) {
  WidgetsBinding.instance!.addPostFrameCallback((_) =>
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        )
    )
  );
}

pop(BuildContext context) {
  WidgetsBinding.instance!.addPostFrameCallback((_) =>
      Navigator.pop(context)
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