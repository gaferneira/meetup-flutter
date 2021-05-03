import 'package:flutter/material.dart';
import '../data/entities/Book.dart';

class BookDetailsPage extends StatefulWidget {
  static const routeName = '/bookDetails';
  BookDetailsPage({Key? key}) : super(key: key);
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Book? book;
  @override
  Widget build(BuildContext context) {
    book = ModalRoute.of(context)!.settings.arguments as Book?;
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Book details"),
        ),
        body: new Center(
          child: Column(
            children: [
              Text(
                book!.name!,
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Container(
                width: double.infinity,
                height: 300,
                alignment: Alignment.center, // This is needed
                child: Image.network(book!.coverUrl!,
                    fit: BoxFit.contain, width: 300),
              ),
              Text(book!.author!)
            ],
          ),
        ));
  }
}
