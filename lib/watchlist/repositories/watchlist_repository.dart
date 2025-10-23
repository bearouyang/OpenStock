import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/watchlist_item.dart';

class WatchlistRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<WatchlistItem>> getWatchlistStream() {
    return _client
        .from('watchlist')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((listOfMaps) => listOfMaps.map((map) => WatchlistItem.fromMap(map)).toList());
  }

  Future<void> addStock(String symbol) async {
    if (_client.auth.currentUser == null) {
      throw Exception('User not authenticated');
    }
    await _client.from('watchlist').insert({
      'user_id': _client.auth.currentUser!.id,
      'symbol': symbol.toUpperCase(),
    });
  }

  Future<void> removeStock(int id) async {
    await _client.from('watchlist').delete().match({'id': id});
  }
}
