import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutWebView extends StatefulWidget {
  final String url;
  final String successIndicator;

  const CheckoutWebView({
    super.key,
    required this.url,
    this.successIndicator = 'success',
  });

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();

    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (url) {
          final l = url.toLowerCase();

          
          
          final checks = [
            widget.successIndicator.toLowerCase(),
            'session_id=',
            'status=success',
            '/success',
            'payment_success',
            'checkout/success',
          ];

          for (final c in checks) {
            if (l.contains(c)) {
              if (mounted) Get.back(result: true);
              return;
            }
          }
        },
        onNavigationRequest: (request) {
          final l = request.url.toLowerCase();
          
          
          if (l.contains('session_id=') ||
              l.contains('/success') ||
              l.contains('status=success')) {
            if (mounted) Get.back(result: true);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.black,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
