import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../repositories/stock_repository.dart';

class StockDetailPage extends ConsumerWidget {
  final String symbol;

  const StockDetailPage({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockDataAsync = ref.watch(stockDataProvider(symbol));

    return Scaffold(
      appBar: AppBar(
        title: Text(symbol.toUpperCase()),
      ),
      body: stockDataAsync.when(
        data: (data) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (data.logo.isNotEmpty)
                      Image.network(data.logo, height: 40, width: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(data.name, style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(data.industry, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 24),
                _buildPriceInfo(context, data),
                const SizedBox(height: 24),
                SizedBox(
                  height: 400,
                  child: TradingViewWidget(symbol: symbol),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context, dynamic data) {
    final isPositive = data.change >= 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Price', style: Theme.of(context).textTheme.titleMedium),
            Text('${data.currentPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Change', style: Theme.of(context).textTheme.titleMedium),
            Text(
              '${data.change.toStringAsFixed(2)} (${data.percentChange.toStringAsFixed(2)}%)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Open: ${data.openPrice.toStringAsFixed(2)}'),
            Text('High: ${data.highPrice.toStringAsFixed(2)}'),
            Text('Low: ${data.lowPrice.toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}

class TradingViewWidget extends StatefulWidget {
  final String symbol;
  const TradingViewWidget({super.key, required this.symbol});

  @override
  State<TradingViewWidget> createState() => _TradingViewWidgetState();
}

class _TradingViewWidgetState extends State<TradingViewWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <title>TradingView Widget</title>
          <style>
            body, html { margin: 0; padding: 0; width: 100%; height: 100%; }
            #tradingview_widget_container { width: 100%; height: 100%; }
          </style>
        </head>
        <body>
          <div id="tradingview_widget_container"></div>
          <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
          <script type="text/javascript">
            new TradingView.widget({
              "autosize": true,
              "symbol": "${widget.symbol}",
              "interval": "D",
              "timezone": "Etc/UTC",
              "theme": "light",
              "style": "1",
              "locale": "en",
              "toolbar_bg": "#f1f3f6",
              "enable_publishing": false,
              "allow_symbol_change": true,
              "container_id": "tradingview_widget_container"
            });
          </script>
        </body>
      </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
