import 'package:espresso_challange/ui/details_screen.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  TextEditingController _controller = TextEditingController();

  List<String> _searchResults = [];

  List<String> _items = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Fig",
    "Grape",
    "Lemon",
    "Mango",
    "Orange",
    "Pineapple",
    "Strawberry",
    "Watermelon",
  ];

  void _onSearchTextChanged(String value) {
    setState(() {
      _searchResults = _items
          .where(
              (item) => item.toLowerCase().contains(value.trim().toLowerCase()))
          .toList();
    });
  }

  Future<List<dynamic>> suggestionsCallback(String pattern) async {
    return Future<List<dynamic>>.delayed(
      const Duration(milliseconds: 50),
      () => [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('lol');
        FocusScope.of(context).unfocus();
        _searchResults = [];
      },
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _searchResults = [];
                });
              },
            ),
          ),
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index]),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => DetailsScreen(
                          title: _items[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchTextChanged,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _searchResults = [];
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                child: SizedBox(
                  height: _searchResults.length * 10 > 200
                      ? 300
                      : _searchResults.length * 60,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_searchResults[index]),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => DetailsScreen(
                              title: _searchResults[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
