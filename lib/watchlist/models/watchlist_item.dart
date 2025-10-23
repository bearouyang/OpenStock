class WatchlistItem {
  final int id;
  final String symbol;
  final String userId;
  final DateTime createdAt;

  WatchlistItem({
    required this.id,
    required this.symbol,
    required this.userId,
    required this.createdAt,
  });

  factory WatchlistItem.fromMap(Map<String, dynamic> map) {
    return WatchlistItem(
      id: map['id'],
      symbol: map['symbol'],
      userId: map['user_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
