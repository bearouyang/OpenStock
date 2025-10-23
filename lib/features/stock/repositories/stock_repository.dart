import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/stock_data.dart';

class StockRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<StockData> getStockData(String symbol) async {
    try {
      final response = await _client.functions.invoke(
        'get-stock-data',
        body: {'symbol': symbol.toUpperCase()},
      );

      if (response.error != null) {
        throw Exception('Failed to invoke edge function: ${response.error!.message}');
      }

      // Check if Finnhub returned an empty object (symbol not found)
      if (response.data['ticker'] == null) {
        throw Exception('Stock symbol not found.');
      }

      return StockData.fromMap(response.data);
    } catch (e) {
      // Re-throw the exception to be caught by the provider
      rethrow;
    }
  }
}

// Repository Provider
final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository();
});

// FutureProvider for fetching stock data
final stockDataProvider = FutureProvider.family<StockData, String>((ref, symbol) {
  final repository = ref.watch(stockRepositoryProvider);
  return repository.getStockData(symbol);
});
