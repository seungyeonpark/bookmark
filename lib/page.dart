import 'package:flutter/material.dart';
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

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BOOKMARK',
          style: TextStyle(
            fontSize: 36,
            fontFamily: 'Rubik Mono One',
            color: Color(0xFF333333),
            letterSpacing: 10.0,
          ),
        ),
        backgroundColor: Colors.transparent,
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
                onTap: () => _openWebView(context, bookmarks[index]['link']!),
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
