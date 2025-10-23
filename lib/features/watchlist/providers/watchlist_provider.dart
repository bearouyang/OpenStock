import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/watchlist_item.dart';
import '../repositories/watchlist_repository.dart';

// Repository Provider
final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

// StreamProvider for the watchlist
final watchlistStreamProvider = StreamProvider<List<WatchlistItem>>((ref) {
  final repository = ref.watch(watchlistRepositoryProvider);
  return repository.getWatchlistStream();
});
