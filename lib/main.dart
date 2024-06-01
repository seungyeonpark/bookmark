import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookmarks',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik Mono One',
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Rubik-Light',
            color: Colors.black87,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black87),
          contentTextStyle: TextStyle(color: Colors.black54),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: TextStyle(color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            side: BorderSide(color: Colors.black87),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadowColor: Colors.black54,
            elevation: 4,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
      ),
      home: BookmarkPage(),
    );
  }
}

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map<String, String>> bookmarks = [];
  final _titleController = TextEditingController();
  final _linkController = TextEditingController();
  bool _isTitleValid = true;
  bool _isLinkValid = true;

  void _addBookmark(String title, String link) {
    setState(() {
      _isTitleValid = title.isNotEmpty;
      _isLinkValid = link.isNotEmpty;
    });

    if (_isTitleValid && _isLinkValid) {
      setState(() {
        bookmarks.add({'title': title, 'link': link});
      });
      Navigator.pop(context);
    }
  }

  void _removeBookmark(int index) {
    setState(() {
      bookmarks.removeAt(index);
    });
  }

  void _showAddBookmarkModal(BuildContext context) {
    _titleController.clear();
    _linkController.clear();
    setState(() {
      _isTitleValid = true;
      _isLinkValid = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    errorText: !_isTitleValid ? 'Please enter a title' : null,
                  ),
                  style: TextStyle(fontFamily: 'Rubik-Light'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _linkController,
                  decoration: InputDecoration(
                    labelText: 'Link',
                    errorText: !_isLinkValid ? 'Please enter a link' : null,
                  ),
                  style: TextStyle(fontFamily: 'Rubik-Light'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _addBookmark(_titleController.text, _linkController.text);
                  },
                  child: Text('Add Bookmark', style: TextStyle(fontFamily: 'Rubik-Light')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.black54,
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'BOOKMARK',
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Rubik Mono One',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              child: ListTile(
                title: Center(
                  child: Text(
                    bookmarks[index]['title']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Rubik-Light',
                    ),
                  ),
                ),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Bookmark'),
                        content: Text('Do you want to delete this bookmark?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.black54)),
                          ),
                          TextButton(
                            onPressed: () {
                              _removeBookmark(index);
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.black87)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookmarkModal(context),
        tooltip: 'Add Bookmark',
        child: Icon(Icons.add),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.black87),
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
  }
}
