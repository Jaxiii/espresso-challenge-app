import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/coins_list/coin_list_bloc.dart';
import '../../features/coins_list/coin_list_event.dart';
import '../../features/coins_list/coin_list_state.dart';
import '../../features/coins_list/coin_list_view.dart';
import '../theme.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<CoinMapDto> _searchResults = [];
  StreamSubscription<CoinListState>? _cryptoSubscription;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CoinListBloc>(context, listen: false)
        .add(FetchCoinListWithMarket());
    _cryptoSubscription = BlocProvider.of<CoinListBloc>(context, listen: false)
        .stream
        .listen((state) {
      if (state is CoinListLoaded) {
        print("Data loaded: ${state.coinList.length} items");
      }
    }, onError: (error) {
      print("Error occurred: $error");
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
    if (!_isSearching) {
      _searchController.clear();
      _searchResults.clear();
    } else {
      _performSearch(_searchController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CpTheme.of(context).backgroundColor,
        title: _isSearching ? _buildSearchField() : Text(widget.title),
        actions: _buildActions(),
      ),
      body: _isSearching && _searchResults.isNotEmpty
          ? _buildSearchResults()
          : CoinListWidget(),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.labelLarge,
      onChanged: _performSearch,
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      BlocProvider.of<CoinListBloc>(context, listen: false).add(
        FetchCoinListWithMarket(),
      );
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final cryptoBloc = BlocProvider.of<CoinListBloc>(context, listen: false);
    cryptoBloc.add(FetchCoinList());
    _cryptoSubscription?.cancel();
    _cryptoSubscription = cryptoBloc.stream.listen((state) {
      if (state is CoinListLoaded) {
        setState(() {
          _searchResults = state.coinList
              .where((coin) =>
                  coin.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }
    });
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_searchResults[index].name),
          onTap: () =>
              DetailsScreen.push(context, id: _searchResults[index].id),
        );
      },
    );
  }

  List<Widget> _buildActions() {
    return _isSearching
        ? [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                BlocProvider.of<CoinListBloc>(context, listen: false).add(
                  FetchCoinListWithMarket(),
                );
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                  _searchResults.clear();
                });
              },
            ),
          ]
        : [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
          ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cryptoSubscription?.cancel();
    super.dispose();
  }
}
