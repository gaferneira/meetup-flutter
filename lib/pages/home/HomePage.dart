import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/entities/Book.dart';
import '../../data/repositories/BooksRepository.dart';
import '../detail/BookDetailsPage.dart';

class HomePage extends StatefulWidget {
  static final title = "Home";

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BooksRepository booksRepository = BooksRepository();
  StreamSubscription? streamSubscription;

  List<Book> books = [];

  @override
  void initState() {
    streamSubscription = booksRepository.fetchAllBooks().listen((newList) {
      setState(() {
        books = newList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Books list"),
      ),
      body: new ListView(
        children: books.map(_buildItem).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          key.currentState!.showSnackBar(new SnackBar(
            content: new Text("//TODO Implement"),
          ));
        },
        tooltip: 'Add Event',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildItem(Book book) {
    return new ListTile(
      title: new Text(book.name!),
      subtitle: new Text('Author: ${book.author}'),
      leading: Image.network(book.coverUrl!),
      onTap: () {
        Navigator.of(context)
            .pushNamed(BookDetailsPage.routeName, arguments: book);
      },
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
}
