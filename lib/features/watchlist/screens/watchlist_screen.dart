import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/watchlist_provider.dart';
import '../../stock/screens/stock_detail_page.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  void _showAddStockDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Stock'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter stock symbol (e.g., AAPL)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final symbol = controller.text.trim();
                if (symbol.isNotEmpty) {
                  ref.read(watchlistRepositoryProvider).addStock(symbol);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistAsync = ref.watch(watchlistStreamProvider);

    return Scaffold(
      body: watchlistAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Your watchlist is empty. Add a stock to get started!'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.symbol),
                subtitle: Text('Added on ${item.createdAt.toLocal().toString().substring(0, 10)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    ref.read(watchlistRepositoryProvider).removeStock(item.id);
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => StockDetailPage(symbol: item.symbol)),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStockDialog(context, ref),
        child: const Icon(Icons.add),
        tooltip: 'Add Stock',
      ),
    );
  }
}
