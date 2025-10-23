import 'package:flutter/material.dart';
import 'stock_detail_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  void _search() {
    final symbol = _controller.text.trim().toUpperCase();
    if (symbol.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => StockDetailPage(symbol: symbol)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Stock')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Enter stock symbol...',
                labelText: 'Symbol',
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _search,
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
