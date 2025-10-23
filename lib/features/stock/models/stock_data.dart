class StockData {
  final String name;
  final String ticker;
  final String logo;
  final String weburl;
  final String industry;
  final double currentPrice; // c
  final double change; // d
  final double percentChange; // dp
  final double highPrice; // h
  final double lowPrice; // l
  final double openPrice; // o

  StockData({
    required this.name,
    required this.ticker,
    required this.logo,
    required this.weburl,
    required this.industry,
    required this.currentPrice,
    required this.change,
    required this.percentChange,
    required this.highPrice,
    required this.lowPrice,
    required this.openPrice,
  });

  factory StockData.fromMap(Map<String, dynamic> map) {
    return StockData(
      name: map['name'] ?? '',
      ticker: map['ticker'] ?? '',
      logo: map['logo'] ?? '',
      weburl: map['weburl'] ?? '',
      industry: map['finnhubIndustry'] ?? '',
      currentPrice: (map['c'] ?? 0.0).toDouble(),
      change: (map['d'] ?? 0.0).toDouble(),
      percentChange: (map['dp'] ?? 0.0).toDouble(),
      highPrice: (map['h'] ?? 0.0).toDouble(),
      lowPrice: (map['l'] ?? 0.0).toDouble(),
      openPrice: (map['o'] ?? 0.0).toDouble(),
    );
  }
}
