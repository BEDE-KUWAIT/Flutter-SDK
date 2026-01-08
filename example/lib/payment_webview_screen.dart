import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String surl;
  final String furl;

  const PaymentWebViewScreen({super.key, required this.paymentUrl, required this.surl, required this.furl});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebError==>${error.description}");
            debugPrint("WebError==>${error.errorCode}");
            debugPrint("WebError==>${error.errorType}");
            debugPrint("WebError==>${error.isForMainFrame}");
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (url.contains("q=success")) {
              Navigator.pop(context, true);
            } else if (url.contains("q=failure")) {
              Navigator.pop(context, false);
            }
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..enableZoom(false)
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
