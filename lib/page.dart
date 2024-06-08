import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'web.dart';

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

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _addBookmark(String title, String link) {
    setState(() {
      _isTitleValid = title.isNotEmpty;
      _isLinkValid = link.isNotEmpty;
    });

    if (_isTitleValid && _isLinkValid) {
      setState(() {
        bookmarks.add({'title': title, 'link': link});
        _saveBookmarks();
      });
      Navigator.pop(context);
    }
  }

  void _removeBookmark(int index) {
    setState(() {
      bookmarks.removeAt(index);
    });
  }

  void _showAddBookmarkModal(BuildContext context, {bool keepValidationState = false}) {
    if (!keepValidationState) {
      _titleController.clear();
      _linkController.clear();

      setState(() {
        _isTitleValid = true;
        _isLinkValid = true;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddBookmarkModal(
          titleController: _titleController,
          linkController: _linkController,
          onAddBookmark: _addBookmark,
        );
      },
    );
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
  }

  void _saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarksStringList = bookmarks.map((bookmark) => jsonEncode(bookmark)).toList();
    await prefs.setStringList('bookmarks', bookmarksStringList);
  }

  void _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarksStringList = prefs.getStringList('bookmarks');
    if (bookmarksStringList != null) {
      setState(() {
        bookmarks = bookmarksStringList
            .map((bookmarkString) => Map<String, String>.from(jsonDecode(bookmarkString)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BOOKMARK'),
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
                      fontFamily: 'Rubik-Light',
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                onTap: () => _openWebView(context, bookmarks[index]['link']!),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Delete Bookmark',
                          style: TextStyle(
                            fontFamily: 'Rubik-Light',
                            color: Color(0xFF333333),
                          ),
                        ),
                        content: Text(
                          'Do you want to delete this bookmark?',
                          style: TextStyle(
                            fontFamily: 'Rubik-Light',
                            color: Color(0xFF333333),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Rubik-Light',
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _removeBookmark(index);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                fontFamily: 'Rubik-Light',
                                color: Color(0xFF333333),
                              ),
                            ),
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
        child: Icon(
          Icons.add_circle,
          size: 52.0,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}

class AddBookmarkModal extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController linkController;
  final Function(String, String) onAddBookmark;

  const AddBookmarkModal({
    Key? key,
    required this.titleController,
    required this.linkController,
    required this.onAddBookmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddBookmarkForm(
        titleController: titleController,
        linkController: linkController,
        onAddBookmark: onAddBookmark,
      ),
    );
  }
}

class AddBookmarkForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController linkController;
  final Function(String, String) onAddBookmark;

  const AddBookmarkForm({
    Key? key,
    required this.titleController,
    required this.linkController,
    required this.onAddBookmark,
  }) : super(key: key);

  @override
  _AddBookmarkFormState createState() => _AddBookmarkFormState();
}

class _AddBookmarkFormState extends State<AddBookmarkForm> {
  bool isTitleValid = true;
  bool isLinkValid = true;

  void _updateErrorLabel(bool isTitleEmpty, bool isLinkEmpty) {
    setState(() {
      isTitleValid = !isTitleEmpty;
      isLinkValid = !isLinkEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: widget.titleController,
            decoration: InputDecoration(
              labelText: 'title',
            ),
            style: TextStyle(
              fontFamily: 'Rubik-Light',
              color: Color(0xFF333333),
            ),
          ),
          if (!isTitleValid)
            Text(
                'Please enter a title'
            ),
          SizedBox(height: 10),
          TextField(
            controller: widget.linkController,
            decoration: InputDecoration(
              labelText: 'link',
            ),
            style: TextStyle(
              fontFamily: 'Rubik-Light',
              color: Color(0xFF333333),
            ),
          ),
          if (!isLinkValid)
            Text(
                'Please enter a link'
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              bool isTitleEmpty = widget.titleController.text.isEmpty;
              bool isLinkEmpty = widget.linkController.text.isEmpty;

              if (isTitleEmpty || isLinkEmpty) {
                _updateErrorLabel(isTitleEmpty, isLinkEmpty);
              } else {
                widget.onAddBookmark(widget.titleController.text, widget.linkController.text);
              }
            },
            child: Text(
              'Add Bookmark',
              style: TextStyle(
                fontFamily: 'Rubik-Light',
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
